import 'package:hive/hive.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/intake_timing.dart';
import 'medication_schedule_model.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 21)
class MedicationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int typeIndex;
  @HiveField(3)
  final String dosage;
  @HiveField(4)
  final String unit;
  @HiveField(5)
  final int intakeTimingIndex;
  @HiveField(6)
  final String notes;
  @HiveField(7)
  final List<TimeValueModel> scheduleTimes;

  MedicationModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    required this.dosage,
    required this.unit,
    required this.intakeTimingIndex,
    required this.notes,
    required this.scheduleTimes,
  });

  factory MedicationModel.fromEntity(Medication medication) {
    return MedicationModel(
      id: medication.id,
      name: medication.name,
      typeIndex: medication.type.index,
      dosage: medication.dosage,
      unit: medication.unit,
      intakeTimingIndex: medication.intakeTiming.index,
      notes: medication.notes,
      scheduleTimes: medication.scheduleTimes
          .map((t) => TimeValueModel.fromEntity(t))
          .toList(),
    );
  }

  Medication toEntity() {
    return Medication(
      id: id,
      name: name,
      type: MedicationType.values[typeIndex],
      dosage: dosage,
      unit: unit,
      intakeTiming: IntakeTiming.values[intakeTimingIndex],
      notes: notes,
      scheduleTimes: scheduleTimes.map((t) => t.toEntity()).toList(),
    );
  }
}
