import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/lab_test.dart';
import '../../domain/usecases/add_lab_test.dart';
import '../../domain/usecases/get_lab_tests.dart';
import '../../domain/usecases/sync_lab_tests.dart';
import 'lab_test_state.dart';

export 'lab_test_state.dart';

class LabTestCubit extends Cubit<LabTestState> {
  final GetLabTests _getLabTests;
  final AddLabTest _addLabTest;
  final SyncLabTests _syncLabTests;

  LabTestCubit({
    required GetLabTests getLabTests,
    required AddLabTest addLabTest,
    required SyncLabTests syncLabTests,
  })  : _getLabTests = getLabTests,
        _addLabTest = addLabTest,
        _syncLabTests = syncLabTests,
        super(const LabTestInitial());

  Future<void> getLabTests() async {
    emit(const LabTestLoading());
    final result = await _getLabTests(NoParams());
    result.fold(
      (failure) => emit(LabTestError(message: failure.message)),
      (labTests) => emit(LabTestLoaded(labTests: labTests)),
    );
  }

  Future<void> addLabTest({required LabTest labTest}) async {
    emit(const LabTestLoading());
    final result = await _addLabTest(labTest);
    result.fold(
      (failure) => emit(LabTestError(message: failure.message)),
      (_) {
        emit(const LabTestActionSuccess(message: 'Lab test added successfully.'));
        getLabTests();
      },
    );
  }

  Future<void> syncLabTests() async {
    emit(const LabTestLoading());
    final result = await _syncLabTests(const NoParams());
    result.fold(
      (failure) => emit(LabTestError(message: failure.message)),
      (_) => getLabTests(),
    );
  }
}
