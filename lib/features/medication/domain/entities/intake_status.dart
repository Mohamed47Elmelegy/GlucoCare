enum IntakeStatus {
  pending,
  taken,
  skipped,
  snoozed;

  bool get isPending => this == IntakeStatus.pending;
  bool get isTaken => this == IntakeStatus.taken;
  bool get isSkipped => this == IntakeStatus.skipped;
  bool get isSnoozed => this == IntakeStatus.snoozed;

  /// Whether a dose in this status still needs a reminder notification.
  /// Snoozed doses keep theirs: it fires at the snooze time.
  bool get needsReminder => isPending || isSnoozed;
}
