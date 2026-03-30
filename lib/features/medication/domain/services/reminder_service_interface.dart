import '../entities/medication.dart';

abstract class ReminderServiceInterface {
  /// Schedules a new reminder alarm for the given medication
  Future<void> scheduleMedicationAlarms(Medication medication);

  /// Cancels all existing reminder alarms for a given medication
  Future<void> cancelMedicationAlarms(String medicationId);

  /// Records a missed dose for the medication and optionally reschedules it
  Future<void> handleMissedDose(
    String medicationId,
    String reason,
    DateTime? rescheduleTime,
  );

  /// Requests permissions for notifications
  Future<bool> requestPermissions();
}
