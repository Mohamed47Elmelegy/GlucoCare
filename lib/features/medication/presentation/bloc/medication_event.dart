import 'package:equatable/equatable.dart';

import '../../domain/entities/medication.dart';
import '../../domain/entities/dose_history.dart';

abstract class MedicationEvent extends Equatable {
  const MedicationEvent();

  @override
  List<Object?> get props => [];
}

class GetMedicationsEvent extends MedicationEvent {
  const GetMedicationsEvent();
}

class AddMedicationEvent extends MedicationEvent {
  final Medication medication;

  const AddMedicationEvent({required this.medication});

  @override
  List<Object?> get props => [medication];
}

class UpdateMedicationEvent extends MedicationEvent {
  final Medication medication;

  const UpdateMedicationEvent({required this.medication});

  @override
  List<Object?> get props => [medication];
}

class DeleteMedicationEvent extends MedicationEvent {
  final String id;

  const DeleteMedicationEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class RescheduleMedicationEvent extends MedicationEvent {
  final String medicationId;
  final String reason;
  final DateTime? rescheduleTime;

  const RescheduleMedicationEvent({
    required this.medicationId,
    required this.reason,
    this.rescheduleTime,
  });

  @override
  List<Object?> get props => [medicationId, reason, rescheduleTime];
}

// Legacy UI Events for Dashboard Compatibility
class LoadTodaySchedule extends MedicationEvent {
  final DateTime date;

  const LoadTodaySchedule(this.date);

  @override
  List<Object?> get props => [date];
}

class MarkMedicationAsTaken extends MedicationEvent {
  final DoseHistory history;

  const MarkMedicationAsTaken(this.history);

  @override
  List<Object?> get props => [history];
}

class SyncMedicationsEvent extends MedicationEvent {
  const SyncMedicationsEvent();
}
