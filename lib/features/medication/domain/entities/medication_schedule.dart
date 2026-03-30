import 'package:equatable/equatable.dart';
import 'time_value.dart';

class MedicationSchedule extends Equatable {
  final String id;
  final String medicationId;
  final List<TimeValue> times;
  final DateTime startDate;
  final DateTime? endDate;
  final bool reminderEnabled;

  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.times,
    required this.startDate,
    this.endDate,
    required this.reminderEnabled,
  });

  @override
  List<Object?> get props => [
    id,
    medicationId,
    times,
    startDate,
    endDate,
    reminderEnabled,
  ];
}
