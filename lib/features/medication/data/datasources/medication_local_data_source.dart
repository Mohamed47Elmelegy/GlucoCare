import '../models/medication_model.dart';
import '../models/medication_schedule_model.dart';
import '../models/dose_history_model.dart';

abstract class MedicationLocalDataSource {
  // Medication
  Future<void> saveMedication(MedicationModel medication);
  Future<List<MedicationModel>> getMedications();
  Future<void> updateMedication(MedicationModel medication);
  Future<void> deleteMedication(String id);

  // Schedules
  Future<void> saveSchedule(MedicationScheduleModel schedule);
  Future<List<MedicationScheduleModel>> getSchedules(String medicationId);

  // Dose History
  Future<void> saveDoseHistory(DoseHistoryModel history);
  Future<List<DoseHistoryModel>> getDoseHistory(String medicationId);
  Future<List<DoseHistoryModel>> getHistoryForDate(DateTime date);
  Future<void> saveAllMedications(List<MedicationModel> medications);
  Future<void> saveAllDoseHistories(List<DoseHistoryModel> histories);
}
