import '../models/medication_model.dart';
import '../models/dose_history_model.dart';

abstract class MedicationLocalDataSource {
  Future<void> saveMedication(MedicationModel medication);
  Future<List<MedicationModel>> getMedications();
  Future<void> updateMedication(MedicationModel medication);
  Future<void> deleteMedication(String id);
  Future<void> saveAllMedications(List<MedicationModel> medications);
  
  // Dose History
  Future<void> saveDoseHistory(DoseHistoryModel history);
  Future<List<DoseHistoryModel>> getDoseHistory(String medicationId);
  Future<List<DoseHistoryModel>> getAllDoseHistory();
  Future<void> saveAllDoseHistories(List<DoseHistoryModel> histories);
}
