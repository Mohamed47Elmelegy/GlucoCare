import 'package:equatable/equatable.dart';
import 'medication_type.dart';
import 'intake_timing.dart';
import 'time_value.dart';

class Medication extends Equatable {
  final String id;
  final String name;
  final MedicationType type;
  final String dosage;
  final String unit;
  final IntakeTiming intakeTiming;
  final String notes;
  final List<TimeValue> scheduleTimes;

  const Medication({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.unit,
    required this.intakeTiming,
    required this.notes,
    this.scheduleTimes = const [],
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    dosage,
    unit,
    intakeTiming,
    notes,
    scheduleTimes,
  ];
}
