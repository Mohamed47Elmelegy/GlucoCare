import 'package:equatable/equatable.dart';

import '../../domain/entities/medication.dart';
import '../../domain/entities/dose_history.dart';

abstract class MedicationState extends Equatable {
  const MedicationState();

  @override
  List<Object?> get props => [];
}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationLoaded extends MedicationState {
  final List<Medication> medications;

  const MedicationLoaded({required this.medications});

  @override
  List<Object?> get props => [medications];
}

class MedicationError extends MedicationState {
  final String message;

  const MedicationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MedicationActionSuccess extends MedicationState {
  final String message;

  const MedicationActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// Legacy UI States for Dashboard Compatibility
class TodayScheduleLoaded extends MedicationState {
  final List<Medication> activeMedications;
  final List<DoseHistory> takenHistory;

  const TodayScheduleLoaded({
    required this.activeMedications,
    required this.takenHistory,
  });

  @override
  List<Object?> get props => [activeMedications, takenHistory];
}
