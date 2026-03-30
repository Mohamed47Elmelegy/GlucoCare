import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_lab_test.dart';
import '../../domain/usecases/get_lab_tests.dart';
import '../../domain/usecases/sync_lab_tests.dart';
import 'lab_test_event.dart';
import 'lab_test_state.dart';

class LabTestBloc extends Bloc<LabTestEvent, LabTestState> {
  final GetLabTests getLabTests;
  final AddLabTest addLabTest;
  final SyncLabTests syncLabTests;

  LabTestBloc({
    required this.getLabTests,
    required this.addLabTest,
    required this.syncLabTests,
  }) : super(LabTestInitial()) {
    on<GetLabTestsEvent>(_onGetLabTests);
    on<AddLabTestEvent>(_onAddLabTest);
    on<SyncLabTestsEvent>(_onSync);
  }

  Future<void> _onGetLabTests(
    GetLabTestsEvent event,
    Emitter<LabTestState> emit,
  ) async {
    emit(LabTestLoading());
    final result = await getLabTests(NoParams());
    result.fold(
      (failure) => emit(LabTestError(message: failure.message)),
      (labTests) => emit(LabTestLoaded(labTests: labTests)),
    );
  }

  Future<void> _onAddLabTest(
    AddLabTestEvent event,
    Emitter<LabTestState> emit,
  ) async {
    emit(LabTestLoading());
    final result = await addLabTest(event.labTest);
    result.fold((failure) => emit(LabTestError(message: failure.message)), (_) {
      emit(const LabTestActionSuccess(message: 'Lab test added successfully.'));
      add(GetLabTestsEvent()); // Refresh list
    });
  }

  Future<void> _onSync(
    SyncLabTestsEvent event,
    Emitter<LabTestState> emit,
  ) async {
    emit(LabTestLoading());
    final result = await syncLabTests(const NoParams());
    result.fold(
      (failure) => emit(LabTestError(message: failure.message)),
      (_) => add(GetLabTestsEvent()),
    );
  }
}
