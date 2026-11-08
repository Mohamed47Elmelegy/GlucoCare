import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/usecases/usecase.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/dose_timeline_entry.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_status.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/failures/intake_failure.dart';
import 'package:flutter_test_ai/features/medication/domain/repositories/intake_repository.dart';
import 'package:flutter_test_ai/features/medication/domain/usecases/get_intake_summary.dart';
import 'package:fpdart/fpdart.dart';

class _FakeIntakeRepository implements IntakeRepository {
  Either<IntakeFailure, List<IntakeTask>> result = const Right([]);
  DateTime? requestedDate;

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> getTasksForDate(DateTime date) async {
    requestedDate = date;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _today = DateTime(2026, 11, 8);

IntakeTask _task(String id, int hour, IntakeStatus status, {MealSlot slot = MealSlot.breakfast}) {
  return IntakeTask(
    id: id,
    medicationId: 'med_$id',
    medicationName: 'Med $id',
    slot: slot,
    scheduledTime: TimeOfDay(hour: hour, minute: 0),
    date: _today,
    status: status,
  );
}

void main() {
  late _FakeIntakeRepository repository;

  setUp(() => repository = _FakeIntakeRepository());

  GetIntakeSummaryUseCase useCaseAt(DateTime now) =>
      GetIntakeSummaryUseCase(repository, clock: () => now);

  test('reads the tasks for the clock date', () async {
    final now = DateTime(2026, 11, 8, 12);

    await useCaseAt(now)(const NoParams());

    expect(repository.requestedDate, now);
  });

  test('orders the timeline by due time regardless of storage order', () async {
    repository.result = Right([
      _task('dinner', 20, IntakeStatus.pending, slot: MealSlot.dinner),
      _task('breakfast', 8, IntakeStatus.taken),
      _task('lunch', 14, IntakeStatus.pending, slot: MealSlot.lunch),
    ]);

    final summary = (await useCaseAt(DateTime(2026, 11, 8, 12))(const NoParams()))
        .getOrElse((_) => throw StateError('expected a summary'));

    expect(summary.timeline.map((e) => e.task.id), ['breakfast', 'lunch', 'dinner']);
  });

  test('next dose is the earliest dose still to take, skipping missed ones', () async {
    repository.result = Right([
      _task('missed', 8, IntakeStatus.pending),
      _task('later', 20, IntakeStatus.pending, slot: MealSlot.dinner),
      _task('soon', 14, IntakeStatus.pending, slot: MealSlot.lunch),
    ]);

    final summary = (await useCaseAt(DateTime(2026, 11, 8, 13))(const NoParams()))
        .getOrElse((_) => throw StateError('expected a summary'));

    expect(summary.nextDose?.task.id, 'soon');
    expect(summary.missedDoses.map((e) => e.task.id), ['missed']);
  });

  test('next dose is null once every dose is taken or skipped', () async {
    repository.result = Right([
      _task('a', 8, IntakeStatus.taken),
      _task('b', 20, IntakeStatus.skipped, slot: MealSlot.dinner),
    ]);

    final summary = (await useCaseAt(DateTime(2026, 11, 8, 9))(const NoParams()))
        .getOrElse((_) => throw StateError('expected a summary'));

    expect(summary.nextDose, isNull);
    expect(summary.missedDoses, isEmpty);
    expect(summary.timeline.map((e) => e.status),
        [DoseTimelineStatus.taken, DoseTimelineStatus.skipped]);
  });

  test('keeps the existing counts', () async {
    repository.result = Right([
      _task('a', 8, IntakeStatus.taken),
      _task('b', 14, IntakeStatus.skipped, slot: MealSlot.lunch),
      _task('c', 20, IntakeStatus.snoozed, slot: MealSlot.dinner),
    ]);

    final summary = (await useCaseAt(DateTime(2026, 11, 8, 9))(const NoParams()))
        .getOrElse((_) => throw StateError('expected a summary'));

    expect(
      [summary.total, summary.taken, summary.skipped, summary.snoozed],
      [3, 1, 1, 1],
    );
  });

  test('passes repository failures through', () async {
    repository.result = const Left(IntakeStorageFailure('disk error'));

    final result = await useCaseAt(DateTime(2026, 11, 8, 9))(const NoParams());

    expect(result, const Left<IntakeFailure, IntakeSummary>(IntakeStorageFailure('disk error')));
  });
}
