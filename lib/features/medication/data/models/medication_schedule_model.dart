import 'package:hive/hive.dart';
import '../../domain/entities/medication_schedule.dart';
import '../../domain/entities/time_value.dart';

part 'medication_schedule_model.g.dart';

@HiveType(typeId: 22)
class MedicationScheduleModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String medicationId;
  @HiveField(2)
  final List<TimeValueModel> times;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
  final DateTime? endDate;
  @HiveField(5)
  final bool reminderEnabled;

  MedicationScheduleModel({
    required this.id,
    required this.medicationId,
    required this.times,
    required this.startDate,
    this.endDate,
    required this.reminderEnabled,
  });

  factory MedicationScheduleModel.fromEntity(MedicationSchedule schedule) {
    return MedicationScheduleModel(
      id: schedule.id,
      medicationId: schedule.medicationId,
      times: schedule.times.map((t) => TimeValueModel.fromEntity(t)).toList(),
      startDate: schedule.startDate,
      endDate: schedule.endDate,
      reminderEnabled: schedule.reminderEnabled,
    );
  }

  MedicationSchedule toEntity() {
    return MedicationSchedule(
      id: id,
      medicationId: medicationId,
      times: times.map((t) => t.toEntity()).toList(),
      startDate: startDate,
      endDate: endDate,
      reminderEnabled: reminderEnabled,
    );
  }
}

@HiveType(typeId: 24)
class TimeValueModel extends HiveObject {
  @HiveField(0)
  final int hour;
  @HiveField(1)
  final int minute;

  TimeValueModel({required this.hour, required this.minute});

  factory TimeValueModel.fromEntity(TimeValue time) {
    return TimeValueModel(hour: time.hour, minute: time.minute);
  }

  TimeValue toEntity() {
    return TimeValue(hour: hour, minute: minute);
  }
}
