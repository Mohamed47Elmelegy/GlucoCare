import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/insulin_reading.dart';
import '../../domain/usecases/add_insulin_reading.dart';
import '../../domain/usecases/get_insulin_readings.dart';
import '../../domain/usecases/sync_insulin_readings.dart';
import 'insulin_state.dart';

export 'insulin_state.dart';

class InsulinCubit extends Cubit<InsulinState> {
  final GetInsulinReadings _getInsulinReadings;
  final AddInsulinReading _addInsulinReading;
  final SyncInsulinReadings _syncInsulinReadings;

  InsulinCubit({
    required GetInsulinReadings getInsulinReadings,
    required AddInsulinReading addInsulinReading,
    required SyncInsulinReadings syncInsulinReadings,
  })  : _getInsulinReadings = getInsulinReadings,
        _addInsulinReading = addInsulinReading,
        _syncInsulinReadings = syncInsulinReadings,
        super(const InsulinInitial());

  Future<void> loadReadings() async {
    emit(const InsulinLoading());
    final result = await _getInsulinReadings();
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (readings) => emit(InsulinLoaded(readings)),
    );
  }

  Future<void> addReading({required InsulinReading reading}) async {
    final result = await _addInsulinReading(reading);
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (_) => emit(const InsulinActionSuccess()),
    );
  }

  Future<void> syncReadings() async {
    emit(const InsulinLoading());
    final result = await _syncInsulinReadings(const NoParams());
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (_) => loadReadings(),
    );
  }
}
