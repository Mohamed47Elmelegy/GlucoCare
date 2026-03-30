import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_insulin_reading.dart';
import '../../domain/usecases/get_insulin_readings.dart';
import '../../domain/usecases/sync_insulin_readings.dart';
import '../../../../core/usecases/usecase.dart';
import 'insulin_event.dart';
import 'insulin_state.dart';

class InsulinBloc extends Bloc<InsulinEvent, InsulinState> {
  final GetInsulinReadings getInsulinReadings;
  final AddInsulinReading addInsulinReading;
  final SyncInsulinReadings syncInsulinReadings;

  InsulinBloc({
    required this.getInsulinReadings,
    required this.addInsulinReading,
    required this.syncInsulinReadings,
  }) : super(InsulinInitial()) {
    on<LoadInsulinReadings>(_onLoad);
    on<AddInsulinReadingEvent>(_onAdd);
    on<SyncInsulinReadingsEvent>(_onSync);
  }

  Future<void> _onLoad(
    LoadInsulinReadings event,
    Emitter<InsulinState> emit,
  ) async {
    emit(InsulinLoading());
    final result = await getInsulinReadings();
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (readings) => emit(InsulinLoaded(readings)),
    );
  }

  Future<void> _onAdd(
    AddInsulinReadingEvent event,
    Emitter<InsulinState> emit,
  ) async {
    // ignore: avoid_print
    print("Saving reading with type: ${event.reading.readingType}");
    final result = await addInsulinReading(event.reading);
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (_) => emit(const InsulinActionSuccess()),
    );
  }

  Future<void> _onSync(
    SyncInsulinReadingsEvent event,
    Emitter<InsulinState> emit,
  ) async {
    emit(InsulinLoading());
    final result = await syncInsulinReadings(const NoParams());
    result.fold(
      (failure) => emit(InsulinError(failure.message)),
      (_) => add(const LoadInsulinReadings()),
    );
  }
}
