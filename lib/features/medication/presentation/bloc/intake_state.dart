import 'package:equatable/equatable.dart';
import '../../domain/entities/intake_task.dart';
import '../../domain/usecases/get_intake_summary.dart';

abstract class IntakeState extends Equatable {
  const IntakeState();

  @override
  List<Object?> get props => [];
}

class IntakeInitial extends IntakeState {}

class IntakeLoading extends IntakeState {}

class IntakeLoaded extends IntakeState {
  final List<IntakeTask> tasks;
  final IntakeSummary summary;

  const IntakeLoaded({
    required this.tasks,
    required this.summary,
  });

  @override
  List<Object?> get props => [tasks, summary];
}

class IntakeFailure extends IntakeState {
  final String message;

  const IntakeFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class IntakeActionSuccess extends IntakeState {
  final String message;
  const IntakeActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
