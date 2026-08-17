import '../../domain/entities/lab_test.dart';

sealed class LabTestState {
  const LabTestState();
}

class LabTestInitial extends LabTestState {
  const LabTestInitial();
}

class LabTestLoading extends LabTestState {
  const LabTestLoading();
}

class LabTestLoaded extends LabTestState {
  final List<LabTest> labTests;
  const LabTestLoaded({required this.labTests});
}

class LabTestActionSuccess extends LabTestState {
  final String message;
  const LabTestActionSuccess({required this.message});
}

class LabTestError extends LabTestState {
  final String message;
  const LabTestError({required this.message});
}
