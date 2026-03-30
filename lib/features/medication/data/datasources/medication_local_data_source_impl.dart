import 'package:hive/hive.dart';
import '../models/medication_model.dart';
import '../models/medication_schedule_model.dart';
import '../models/dose_history_model.dart';
import 'medication_local_data_source.dart';

class MedicationLocalDataSourceImpl implements MedicationLocalDataSource {
  final Box<MedicationModel> medicationBox;
  final Box<MedicationScheduleModel> scheduleBox;
  final Box<DoseHistoryModel> doseHistoryBox;

  MedicationLocalDataSourceImpl({
    required this.medicationBox,
    required this.scheduleBox,
    required this.doseHistoryBox,
  });

  @override
  Future<void> saveMedication(MedicationModel medication) async {
    await medicationBox.put(medication.id, medication);
  }

  @override
  Future<List<MedicationModel>> getMedications() async {
    return medicationBox.values.toList();
  }

  @override
  Future<void> updateMedication(MedicationModel medication) async {
    await medicationBox.put(medication.id, medication);
  }

  @override
  Future<void> deleteMedication(String id) async {
    await medicationBox.delete(id);
  }

  @override
  Future<void> saveSchedule(MedicationScheduleModel schedule) async {
    await scheduleBox.put(schedule.id, schedule);
  }

  @override
  Future<List<MedicationScheduleModel>> getSchedules(
    String medicationId,
  ) async {
    return scheduleBox.values
        .where((s) => s.medicationId == medicationId)
        .toList();
  }

  @override
  Future<void> saveDoseHistory(DoseHistoryModel history) async {
    await doseHistoryBox.put(history.id, history);
  }

  @override
  Future<List<DoseHistoryModel>> getDoseHistory(String medicationId) async {
    return doseHistoryBox.values
        .where((h) => h.medicationId == medicationId)
        .toList();
  }

  @override
  Future<List<DoseHistoryModel>> getHistoryForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return doseHistoryBox.values
        .where(
          (h) =>
              h.dateTime.isAfter(startOfDay) && h.dateTime.isBefore(endOfDay),
        )
        .toList();
  }

  @override
  Future<void> saveAllMedications(List<MedicationModel> medications) async {
    final Map<String, MedicationModel> map = {
      for (var m in medications) m.id: m,
    };
    await medicationBox.putAll(map);
  }

  @override
  Future<void> saveAllDoseHistories(List<DoseHistoryModel> histories) async {
    final Map<String, DoseHistoryModel> map = {
      for (var h in histories) h.id: h,
    };
    await doseHistoryBox.putAll(map);
  }
}
