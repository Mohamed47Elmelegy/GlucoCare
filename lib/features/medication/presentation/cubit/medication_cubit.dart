import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/dose_history.dart';
import '../../domain/entities/medication.dart';
import '../../domain/usecases/add_medication.dart';
import '../../domain/usecases/delete_medication.dart';
import '../../domain/usecases/get_history_for_date.dart';
import '../../domain/usecases/get_medications.dart';
import '../../domain/usecases/record_medication_history.dart';
import '../../domain/usecases/reschedule_medication.dart';
import '../../domain/usecases/sync_medications.dart';
import '../../domain/usecases/update_medication.dart';
import 'medication_state.dart';

export 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final AddMedication _addMedication;
  final UpdateMedication _updateMedication;
  final DeleteMedication _deleteMedication;
  final GetMedications _getMedications;
  final RescheduleMedication _rescheduleMedication;
  final GetHistoryForDate _getHistoryForDate;
  final RecordMedicationHistory _recordMedicationHistory;
  final SyncMedications _syncMedications;

  MedicationCubit({
    required AddMedication addMedication,
    required UpdateMedication updateMedication,
    required DeleteMedication deleteMedication,
    required GetMedications getMedications,
    required RescheduleMedication rescheduleMedication,
    required GetHistoryForDate getHistoryForDate,
    required RecordMedicationHistory recordMedicationHistory,
    required SyncMedications syncMedications,
  })  : _addMedication = addMedication,
        _updateMedication = updateMedication,
        _deleteMedication = deleteMedication,
        _getMedications = getMedications,
        _rescheduleMedication = rescheduleMedication,
        _getHistoryForDate = getHistoryForDate,
        _recordMedicationHistory = recordMedicationHistory,
        _syncMedications = syncMedications,
        super(const MedicationInitial());

  Future<void> getMedications() async {
    emit(const MedicationLoading());
    final result = await _getMedications(NoParams());
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (medications) => emit(MedicationLoaded(medications: medications)),
    );
  }

  Future<void> addMedication({required Medication medication}) async {
    emit(const MedicationLoading());
    final result = await _addMedication(
      AddMedicationParams(medication: medication),
    );
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => emit(const MedicationActionSuccess(
        message: 'Medication added successfully.',
      )),
    );
  }

  Future<void> updateMedication({required Medication medication}) async {
    emit(const MedicationLoading());
    final result = await _updateMedication(
      UpdateMedicationParams(medication: medication),
    );
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => emit(const MedicationActionSuccess(
        message: 'Medication updated successfully.',
      )),
    );
  }

  Future<void> deleteMedication({required String id}) async {
    emit(const MedicationLoading());
    final result = await _deleteMedication(DeleteMedicationParams(id: id));
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => emit(const MedicationActionSuccess(
        message: 'Medication deleted successfully.',
      )),
    );
  }

  Future<void> rescheduleMedication({
    required String medicationId,
    required String reason,
    DateTime? rescheduleTime,
  }) async {
    emit(const MedicationLoading());
    final result = await _rescheduleMedication(
      RescheduleMedicationParams(
        medicationId: medicationId,
        reason: reason,
        rescheduleTime: rescheduleTime,
      ),
    );
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => emit(const MedicationActionSuccess(
        message: 'Medication rescheduled successfully.',
      )),
    );
  }

  Future<void> loadTodaySchedule({required DateTime date}) async {
    emit(const MedicationLoading());
    final medsResult = await _getMedications(NoParams());
    final historyResult = await _getHistoryForDate(date);

    medsResult.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (medications) {
        historyResult.fold(
          (failure) => emit(MedicationError(message: failure.message)),
          (history) => emit(TodayScheduleLoaded(
            activeMedications: medications,
            takenHistory: history,
          )),
        );
      },
    );
  }

  Future<void> markMedicationAsTaken({required DoseHistory history}) async {
    final result = await _recordMedicationHistory(history);
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => emit(const MedicationActionSuccess(
        message: 'Medication marked as taken.',
      )),
    );
  }

  Future<void> syncMedications() async {
    emit(const MedicationLoading());
    final result = await _syncMedications(const NoParams());
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (_) => getMedications(),
    );
  }
}
