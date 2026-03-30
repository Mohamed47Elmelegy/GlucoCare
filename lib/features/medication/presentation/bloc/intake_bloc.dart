import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/generate_daily_intake_tasks.dart';
import '../../domain/usecases/get_intake_summary.dart';
import '../../domain/usecases/get_today_intake_tasks.dart';
import '../../domain/usecases/mark_intake_task.dart';
import '../../domain/usecases/schedule_all_reminders.dart';
import '../../domain/usecases/cancel_reminder.dart';
import 'intake_event.dart';
import 'intake_state.dart';

class IntakeBloc extends Bloc<IntakeEvent, IntakeState> {
  final GenerateDailyIntakeTasksUseCase generateDailyIntakeTasks;
  final GetTodayIntakeTasksUseCase getTodayIntakeTasks;
  final MarkIntakeTaskUseCase markIntakeTask;
  final GetIntakeSummaryUseCase getIntakeSummary;
  final ScheduleAllRemindersUseCase scheduleAllReminders;
  final CancelReminderUseCase cancelReminder;

  IntakeBloc({
    required this.generateDailyIntakeTasks,
    required this.getTodayIntakeTasks,
    required this.markIntakeTask,
    required this.getIntakeSummary,
    required this.scheduleAllReminders,
    required this.cancelReminder,
  }) : super(IntakeInitial()) {
    on<IntakeTasksLoadRequested>(_onLoadTasks);
    on<IntakeTaskStatusChanged>(_onStatusChanged);
  }

  Future<void> _onLoadTasks(
    IntakeTasksLoadRequested event,
    Emitter<IntakeState> emit,
  ) async {
    emit(IntakeLoading());
    
    // 1. Generate tasks for the date (idempotent)
    final genResult = await generateDailyIntakeTasks(event.date);
    if (genResult.isLeft()) {
      genResult.fold(
        (failure) => emit(IntakeFailure(message: failure.message)),
        (_) => null,
      );
      return;
    }

    // NEW: Request permissions first
    await scheduleAllReminders.notificationService.requestPermissions();

    // NEW: Schedule all reminders for today
    await scheduleAllReminders(const NoParams());

    // 2. Load tasks and summary
    final tasksResult = await getTodayIntakeTasks(const NoParams());
    final summaryResult = await getIntakeSummary(const NoParams());

    await tasksResult.fold(
      (failure) async => emit(IntakeFailure(message: failure.message)),
      (tasks) async {
        // Interaction = App open = cancel all pending repeats for tasks that are already handled
        for (final task in tasks) {
          if (!task.status.isPending) {
             await cancelReminder(task.id);
          }
        }

        summaryResult.fold(
          (failure) => emit(IntakeFailure(message: failure.message)),
          (summary) => emit(IntakeLoaded(tasks: tasks, summary: summary)),
        );
      },
    );
  }

  Future<void> _onStatusChanged(
    IntakeTaskStatusChanged event,
    Emitter<IntakeState> emit,
  ) async {
    final result = await markIntakeTask(
      MarkIntakeTaskParams(
        taskId: event.taskId,
        status: event.status,
        takenAt: event.takenAt,
        snoozeUntil: event.snoozeUntil,
      ),
    );

    await result.fold(
      (failure) async => emit(IntakeFailure(message: failure.message)),
      (_) async {
        // Cancel reminders for this specific task immediately
        await cancelReminder(event.taskId);

        final message = event.status.name[0].toUpperCase() + event.status.name.substring(1);
        emit(IntakeActionSuccess(message: 'Task marked as $message'));
        add(IntakeTasksLoadRequested(date: DateTime.now())); // Refresh
      },
    );
  }
}
