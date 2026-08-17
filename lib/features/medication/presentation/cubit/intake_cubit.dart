import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/usecases/cancel_reminder.dart';
import '../../domain/usecases/generate_daily_intake_tasks.dart';
import '../../domain/usecases/get_intake_summary.dart';
import '../../domain/usecases/get_today_intake_tasks.dart';
import '../../domain/usecases/mark_intake_task.dart';
import '../../domain/usecases/schedule_all_reminders.dart';
import 'intake_state.dart';

export 'intake_state.dart';

class IntakeCubit extends Cubit<IntakeState> {
  final GenerateDailyIntakeTasksUseCase _generateDailyIntakeTasks;
  final GetTodayIntakeTasksUseCase _getTodayIntakeTasks;
  final MarkIntakeTaskUseCase _markIntakeTask;
  final GetIntakeSummaryUseCase _getIntakeSummary;
  final ScheduleAllRemindersUseCase _scheduleAllReminders;
  final CancelReminderUseCase _cancelReminder;

  IntakeCubit({
    required GenerateDailyIntakeTasksUseCase generateDailyIntakeTasks,
    required GetTodayIntakeTasksUseCase getTodayIntakeTasks,
    required MarkIntakeTaskUseCase markIntakeTask,
    required GetIntakeSummaryUseCase getIntakeSummary,
    required ScheduleAllRemindersUseCase scheduleAllReminders,
    required CancelReminderUseCase cancelReminder,
  })  : _generateDailyIntakeTasks = generateDailyIntakeTasks,
        _getTodayIntakeTasks = getTodayIntakeTasks,
        _markIntakeTask = markIntakeTask,
        _getIntakeSummary = getIntakeSummary,
        _scheduleAllReminders = scheduleAllReminders,
        _cancelReminder = cancelReminder,
        super(const IntakeInitial());

  Future<void> loadTasks({required DateTime date}) async {
    emit(const IntakeLoading());

    // 1. Generate tasks for the date (idempotent)
    final genResult = await _generateDailyIntakeTasks(date);
    if (genResult.isLeft()) {
      genResult.fold(
        (failure) => emit(IntakeFailure(message: failure.message)),
        (_) => null,
      );
      return;
    }

    // 2. Request permissions and schedule reminders
    await _scheduleAllReminders.notificationService.requestPermissions();
    await _scheduleAllReminders(const NoParams());

    // 3. Load tasks and summary
    final tasksResult = await _getTodayIntakeTasks(const NoParams());
    final summaryResult = await _getIntakeSummary(const NoParams());

    await tasksResult.fold(
      (failure) async => emit(IntakeFailure(message: failure.message)),
      (tasks) async {
        // Cancel reminders for tasks already handled
        for (final task in tasks) {
          if (!task.status.isPending) {
            await _cancelReminder(task.id);
          }
        }
        summaryResult.fold(
          (failure) => emit(IntakeFailure(message: failure.message)),
          (summary) => emit(IntakeLoaded(tasks: tasks, summary: summary)),
        );
      },
    );
  }

  Future<void> changeTaskStatus({
    required String taskId,
    required IntakeStatus status,
    DateTime? takenAt,
    DateTime? snoozeUntil,
  }) async {
    final result = await _markIntakeTask(
      MarkIntakeTaskParams(
        taskId: taskId,
        status: status,
        takenAt: takenAt,
        snoozeUntil: snoozeUntil,
      ),
    );

    await result.fold(
      (failure) async => emit(IntakeFailure(message: failure.message)),
      (_) async {
        await _cancelReminder(taskId);
        final label = status.name[0].toUpperCase() + status.name.substring(1);
        emit(IntakeActionSuccess(message: 'Task marked as $label'));
        await loadTasks(date: DateTime.now());
      },
    );
  }
}
