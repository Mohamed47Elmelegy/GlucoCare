import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_medication.dart';
import '../../domain/usecases/delete_medication.dart';
import '../../domain/usecases/get_history_for_date.dart';
import '../../domain/usecases/get_medications.dart';
import '../../domain/usecases/record_medication_history.dart';
import '../../domain/usecases/reschedule_medication.dart';
import '../../domain/usecases/update_medication.dart';
import '../../domain/usecases/sync_medications.dart';
import 'medication_event.dart';
import 'medication_state.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final AddMedication addMedication;
  final UpdateMedication updateMedication;
  final DeleteMedication deleteMedication;
  final GetMedications getMedications;
  final RescheduleMedication rescheduleMedication;
  final GetHistoryForDate getHistoryForDate;
  final RecordMedicationHistory recordMedicationHistory;
  final SyncMedications syncMedications;

  MedicationBloc({
    required this.addMedication,
    required this.updateMedication,
    required this.deleteMedication,
    required this.getMedications,
    required this.rescheduleMedication,
    required this.getHistoryForDate,
    required this.recordMedicationHistory,
    required this.syncMedications,
  }) : super(MedicationInitial()) {
    on<GetMedicationsEvent>(_onGetMedications);
    on<AddMedicationEvent>(_onAddMedication);
    on<UpdateMedicationEvent>(_onUpdateMedication);
    on<DeleteMedicationEvent>(_onDeleteMedication);
    on<RescheduleMedicationEvent>(_onRescheduleMedication);
    on<LoadTodaySchedule>(_onLoadTodaySchedule);
    on<MarkMedicationAsTaken>(_onMarkMedicationAsTaken);
    on<SyncMedicationsEvent>(_onSyncMedications);
  }

  Future<void> _onGetMedications(
    GetMedicationsEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await getMedications(NoParams());
    result.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (medications) => emit(MedicationLoaded(medications: medications)),
    );
  }

  Future<void> _onAddMedication(
    AddMedicationEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await addMedication(
      AddMedicationParams(medication: event.medication),
    );
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      emit(
        const MedicationActionSuccess(
          message: 'Medication added successfully.',
        ),
      );
    });
  }

  Future<void> _onUpdateMedication(
    UpdateMedicationEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await updateMedication(
      UpdateMedicationParams(medication: event.medication),
    );
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      emit(
        const MedicationActionSuccess(
          message: 'Medication updated successfully.',
        ),
      );
    });
  }

  Future<void> _onDeleteMedication(
    DeleteMedicationEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await deleteMedication(DeleteMedicationParams(id: event.id));
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      emit(
        const MedicationActionSuccess(
          message: 'Medication deleted successfully.',
        ),
      );
    });
  }

  Future<void> _onRescheduleMedication(
    RescheduleMedicationEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await rescheduleMedication(
      RescheduleMedicationParams(
        medicationId: event.medicationId,
        reason: event.reason,
        rescheduleTime: event.rescheduleTime,
      ),
    );
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      emit(
        const MedicationActionSuccess(
          message: 'Medication rescheduled successfully.',
        ),
      );
    });
  }

  Future<void> _onLoadTodaySchedule(
    LoadTodaySchedule event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final medsResult = await getMedications(NoParams());
    final historyResult = await getHistoryForDate(event.date);

    medsResult.fold(
      (failure) => emit(MedicationError(message: failure.message)),
      (medications) {
        historyResult.fold(
          (failure) => emit(MedicationError(message: failure.message)),
          (history) => emit(
            TodayScheduleLoaded(
              activeMedications: medications,
              takenHistory: history,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMarkMedicationAsTaken(
    MarkMedicationAsTaken event,
    Emitter<MedicationState> emit,
  ) async {
    final result = await recordMedicationHistory(event.history);
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      emit(
        const MedicationActionSuccess(message: 'Medication marked as taken.'),
      );
    });
  }

  Future<void> _onSyncMedications(
    SyncMedicationsEvent event,
    Emitter<MedicationState> emit,
  ) async {
    emit(MedicationLoading());
    final result = await syncMedications(const NoParams());
    result.fold((failure) => emit(MedicationError(message: failure.message)), (
      _,
    ) {
      add(const GetMedicationsEvent()); // Refresh list
    });
  }
}
