import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/services/notification_service.dart';
import 'package:flutter_test_ai/core/usecases/usecase.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_status.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/failures/intake_failure.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/intake_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/schedule_all_reminders.dart';
import 'package:fpdart/fpdart.dart';

class _FakeIntakeRepository implements IntakeRepository {
  List<IntakeTask> tasks = [];

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date) async =>
      Right(tasks);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingNotificationService implements NotificationService {
  final List<String> scheduledTaskIds = [];

  @override
  Future<void> scheduleTaskReminder(IntakeTask task) async {
    scheduledTaskIds.add(task.id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

IntakeTask _task(String id, IntakeStatus status) {
  return IntakeTask(
    id: id,
    medicationId: 'med',
    medicationName: 'Metformin',
    slot: MealSlot.breakfast,
    scheduledTime: const TimeOfDay(hour: 8, minute: 0),
    date: DateTime(2026, 11, 8),
    status: status,
  );
}

void main() {
  test('needsReminder is true only for pending and snoozed doses', () {
    expect(
      {for (final s in IntakeStatus.values) s: s.needsReminder},
      {
        IntakeStatus.pending: true,
        IntakeStatus.taken: false,
        IntakeStatus.skipped: false,
        IntakeStatus.snoozed: true,
      },
    );
  });

  test('schedules reminders for pending and snoozed doses only', () async {
    final repository = _FakeIntakeRepository()
      ..tasks = [
        _task('pending', IntakeStatus.pending),
        _task('taken', IntakeStatus.taken),
        _task('skipped', IntakeStatus.skipped),
        _task('snoozed', IntakeStatus.snoozed),
      ];
    final notifications = _RecordingNotificationService();

    final result = await ScheduleAllRemindersUseCase(repository, notifications)(
      const NoParams(),
    );

    expect(result.isRight(), isTrue);
    expect(notifications.scheduledTaskIds, ['pending', 'snoozed']);
  });
}
