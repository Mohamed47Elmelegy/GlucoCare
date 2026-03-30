enum IntakeStatus {
  pending,
  taken,
  skipped,
  snoozed;

  bool get isPending => this == IntakeStatus.pending;
  bool get isTaken => this == IntakeStatus.taken;
  bool get isSkipped => this == IntakeStatus.skipped;
  bool get isSnoozed => this == IntakeStatus.snoozed;
}
