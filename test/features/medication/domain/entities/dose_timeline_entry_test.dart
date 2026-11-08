import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/dose_timeline_entry.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_status.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/intake_task.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';

final _today = DateTime(2026, 11, 8);

IntakeTask _task({
  IntakeStatus status = IntakeStatus.pending,
  TimeOfDay time = const TimeOfDay(hour: 8, minute: 0),
  DateTime? snoozeUntil,
}) {
  return IntakeTask(
    id: 'task',
    medicationId: 'med',
    medicationName: 'Metformin',
    slot: MealSlot.breakfast,
    scheduledTime: time,
    date: _today,
    status: status,
    snoozeUntil: snoozeUntil,
  );
}

void main() {
  group('DoseTimelineEntry.resolve', () {
    test('pending dose before its due time is upcoming', () {
      final entry = DoseTimelineEntry.resolve(_task(), DateTime(2026, 11, 8, 7));

      expect(entry.status, DoseTimelineStatus.upcoming);
      expect(entry.dueAt, DateTime(2026, 11, 8, 8));
    });

    test('pending dose within the 30-minute grace period is still upcoming', () {
      final entry = DoseTimelineEntry.resolve(_task(), DateTime(2026, 11, 8, 8, 30));

      expect(entry.status, DoseTimelineStatus.upcoming);
    });

    test('pending dose past the grace period is missed', () {
      final entry = DoseTimelineEntry.resolve(_task(), DateTime(2026, 11, 8, 8, 31));

      expect(entry.status, DoseTimelineStatus.missed);
    });

    test('snoozed dose is due at its snooze time', () {
      final snoozeUntil = DateTime(2026, 11, 8, 8, 15);
      final entry = DoseTimelineEntry.resolve(
        _task(status: IntakeStatus.snoozed, snoozeUntil: snoozeUntil),
        DateTime(2026, 11, 8, 8, 40),
      );

      expect(entry.status, DoseTimelineStatus.snoozed);
      expect(entry.dueAt, snoozeUntil);
    });

    test('snoozed dose past its snooze time plus grace is missed', () {
      final entry = DoseTimelineEntry.resolve(
        _task(
          status: IntakeStatus.snoozed,
          snoozeUntil: DateTime(2026, 11, 8, 8, 15),
        ),
        DateTime(2026, 11, 8, 8, 46),
      );

      expect(entry.status, DoseTimelineStatus.missed);
    });

    test('taken dose stays taken however late it is', () {
      final entry = DoseTimelineEntry.resolve(
        _task(status: IntakeStatus.taken),
        DateTime(2026, 11, 8, 23),
      );

      expect(entry.status, DoseTimelineStatus.taken);
    });

    test('skipped dose stays skipped however late it is', () {
      final entry = DoseTimelineEntry.resolve(
        _task(status: IntakeStatus.skipped),
        DateTime(2026, 11, 8, 23),
      );

      expect(entry.status, DoseTimelineStatus.skipped);
    });
  });
}
