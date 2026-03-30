import 'package:equatable/equatable.dart';
import '../../domain/entities/lab_test.dart';

abstract class LabTestEvent extends Equatable {
  const LabTestEvent();

  @override
  List<Object?> get props => [];
}

class GetLabTestsEvent extends LabTestEvent {}

class AddLabTestEvent extends LabTestEvent {
  final LabTest labTest;

  const AddLabTestEvent({required this.labTest});

  @override
  List<Object?> get props => [labTest];
}

class DeleteLabTestEvent extends LabTestEvent {
  final String id;

  const DeleteLabTestEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class SyncLabTestsEvent extends LabTestEvent {
  const SyncLabTestsEvent();
}
