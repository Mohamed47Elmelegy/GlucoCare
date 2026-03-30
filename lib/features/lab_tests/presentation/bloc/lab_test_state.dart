import 'package:equatable/equatable.dart';
import '../../domain/entities/lab_test.dart';

abstract class LabTestState extends Equatable {
  const LabTestState();

  @override
  List<Object?> get props => [];
}

class LabTestInitial extends LabTestState {}

class LabTestLoading extends LabTestState {}

class LabTestLoaded extends LabTestState {
  final List<LabTest> labTests;

  const LabTestLoaded({required this.labTests});

  @override
  List<Object?> get props => [labTests];
}

class LabTestActionSuccess extends LabTestState {
  final String message;

  const LabTestActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LabTestError extends LabTestState {
  final String message;

  const LabTestError({required this.message});

  @override
  List<Object?> get props => [message];
}
