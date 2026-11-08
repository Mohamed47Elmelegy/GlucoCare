import 'package:equatable/equatable.dart';
import 'intake_status.dart';
import 'intake_task.dart';

/// How one of today's doses stands at a given moment.
enum DoseTimelineStatus { taken, skipped, snoozed, missed, upcoming }

/// A dose from today's schedule, resolved against the current time.
class DoseTimelineEntry extends Equatable {
  /// A dose still not taken this long after it was due counts as missed.
  /// Matches the last repeat reminder (10/20/30 min), so a dose isn't flagged
  /// while its reminders are still firing.
  static const Duration missedAfter = Duration(minutes: 30);

  final IntakeTask task;

  /// When the dose is due: the snooze time for snoozed doses, otherwise the
  /// scheduled time on the task's date.
  final DateTime dueAt;
  final DoseTimelineStatus status;

  const DoseTimelineEntry({
    required this.task,
    required this.dueAt,
    required this.status,
  });

  factory DoseTimelineEntry.resolve(IntakeTask task, DateTime now) {
    final snoozeUntil = task.snoozeUntil;
    final dueAt = task.status.isSnoozed && snoozeUntil != null
        ? snoozeUntil
        : DateTime(
            task.date.year,
            task.date.month,
            task.date.day,
            task.scheduledTime.hour,
            task.scheduledTime.minute,
          );
    final isOverdue = now.isAfter(dueAt.add(missedAfter));

    final status = switch (task.status) {
      IntakeStatus.taken => DoseTimelineStatus.taken,
      IntakeStatus.skipped => DoseTimelineStatus.skipped,
      IntakeStatus.pending || IntakeStatus.snoozed when isOverdue =>
        DoseTimelineStatus.missed,
      IntakeStatus.snoozed => DoseTimelineStatus.snoozed,
      IntakeStatus.pending => DoseTimelineStatus.upcoming,
    };

    return DoseTimelineEntry(task: task, dueAt: dueAt, status: status);
  }

  /// Still waiting to be taken and not yet missed.
  bool get isUpcoming =>
      status == DoseTimelineStatus.upcoming ||
      status == DoseTimelineStatus.snoozed;

  bool get isMissed => status == DoseTimelineStatus.missed;

  @override
  List<Object?> get props => [task, dueAt, status];
}
