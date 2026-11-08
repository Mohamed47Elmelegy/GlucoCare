import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/services/notification_service.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_status.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/failures/intake_failure.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/intake_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/cancel_reminder.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/generate_daily_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_intake_summary.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_today_intake_tasks.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/mark_intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/schedule_all_reminders.dart';
import 'package:flutter_test_ai/features/medication/presentation/cubit/intake_cubit.dart' show IntakeCubit;
import 'package:fpdart/fpdart.dart';

class _FakeIntakeRepository implements IntakeRepository {
  List<IntakeTask> tasks = [];

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> generateDailyTasks(DateTime date) async =>
      Right(tasks);

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date) async =>
      Right(tasks);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingNotificationService implements NotificationService {
  final List<String> scheduled = [];
  final List<String> cancelled = [];

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> scheduleTaskReminder(IntakeTask task) async => scheduled.add(task.id);

  @override
  Future<void> cancelTaskReminder(String taskId) async => cancelled.add(taskId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

IntakeTask _task(String id, IntakeStatus status) {
  return IntakeTask(
    id: id,
    medicationId: 'med_$id',
    medicationName: 'Med $id',
    slot: MealSlot.breakfast,
    scheduledTime: const TimeOfDay(hour: 8, minute: 0),
    date: DateTime(2026, 11, 8),
    status: status,
    snoozeUntil: status == IntakeStatus.snoozed ? DateTime(2026, 11, 8, 8, 15) : null,
  );
}

void main() {
  late _FakeIntakeRepository repository;
  late _RecordingNotificationService notifications;
  late IntakeCubit cubit;

  setUp(() {
    repository = _FakeIntakeRepository();
    notifications = _RecordingNotificationService();
    cubit = IntakeCubit(
      generateDailyIntakeTasks: GenerateDailyIntakeTasksUseCase(repository),
      getTodayIntakeTasks: GetTodayIntakeTasksUseCase(repository),
      markIntakeTask: MarkIntakeTaskUseCase(repository),
      getIntakeSummary: GetIntakeSummaryUseCase(repository),
      scheduleAllReminders: ScheduleAllRemindersUseCase(repository, notifications),
      cancelReminder: CancelReminderUseCase(notifications),
    );
  });

  tearDown(() => cubit.close());

  // Regression: loadTasks used to cancel every non-pending reminder, which
  // removed the reminder a snooze had just scheduled.
  test('loadTasks keeps the reminder of a snoozed dose', () async {
    repository.tasks = [_task('snoozed', IntakeStatus.snoozed)];

    await cubit.loadTasks(date: DateTime(2026, 11, 8));

    expect(notifications.scheduled, contains('snoozed'));
    expect(notifications.cancelled, isNot(contains('snoozed')));
  });

  test('loadTasks cancels reminders of taken and skipped doses', () async {
    repository.tasks = [
      _task('taken', IntakeStatus.taken),
      _task('skipped', IntakeStatus.skipped),
      _task('pending', IntakeStatus.pending),
    ];

    await cubit.loadTasks(date: DateTime(2026, 11, 8));

    expect(notifications.cancelled, unorderedEquals(['taken', 'skipped']));
  });
}
