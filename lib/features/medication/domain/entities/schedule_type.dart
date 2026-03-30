enum ScheduleType {
  daily,
  fixedDuration;

  String get label {
    switch (this) {
      case ScheduleType.daily:
        return 'Everyday';
      case ScheduleType.fixedDuration:
        return 'Fixed Duration';
    }
  }
}
