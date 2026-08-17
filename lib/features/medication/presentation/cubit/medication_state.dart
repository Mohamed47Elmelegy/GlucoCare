import '../../domain/entities/medication.dart';
import '../../domain/entities/dose_history.dart';

sealed class MedicationState {
  const MedicationState();
}

class MedicationInitial extends MedicationState {
  const MedicationInitial();
}

class MedicationLoading extends MedicationState {
  const MedicationLoading();
}

class MedicationLoaded extends MedicationState {
  final List<Medication> medications;
  const MedicationLoaded({required this.medications});
}

class TodayScheduleLoaded extends MedicationState {
  final List<Medication> activeMedications;
  final List<DoseHistory> takenHistory;
  const TodayScheduleLoaded({
    required this.activeMedications,
    required this.takenHistory,
  });
}

class MedicationActionSuccess extends MedicationState {
  final String message;
  const MedicationActionSuccess({required this.message});
}

class MedicationError extends MedicationState {
  final String message;
  const MedicationError({required this.message});
}
