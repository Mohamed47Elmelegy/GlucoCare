import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/generate_daily_intake_tasks.dart';
import '../../domain/usecases/get_intake_summary.dart';
import '../../domain/usecases/get_today_intake_tasks.dart';
import '../../domain/usecases/mark_intake_task.dart';
import 'intake_event.dart';
import 'intake_state.dart';

class IntakeBloc extends Bloc<IntakeEvent, IntakeState> {
  final GenerateDailyIntakeTasksUseCase generateDailyIntakeTasks;
  final GetTodayIntakeTasksUseCase getTodayIntakeTasks;
  final MarkIntakeTaskUseCase markIntakeTask;
  final GetIntakeSummaryUseCase getIntakeSummary;

  IntakeBloc({
    required this.generateDailyIntakeTasks,
    required this.getTodayIntakeTasks,
    required this.markIntakeTask,
    required this.getIntakeSummary,
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

    // 2. Load tasks and summary
    final tasksResult = await getTodayIntakeTasks(const NoParams());
    final summaryResult = await getIntakeSummary(const NoParams());

    tasksResult.fold(
      (failure) => emit(IntakeFailure(message: failure.message)),
      (tasks) {
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

    result.fold(
      (failure) => emit(IntakeFailure(message: failure.message)),
      (_) {
        final message = event.status.name[0].toUpperCase() + event.status.name.substring(1);
        emit(IntakeActionSuccess(message: 'Task marked as $message'));
        add(IntakeTasksLoadRequested(date: DateTime.now())); // Refresh
      },
    );
  }
}
