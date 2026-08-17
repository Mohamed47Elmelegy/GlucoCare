import '../../domain/entities/intake_task.dart';
import '../../domain/usecases/get_intake_summary.dart';

sealed class IntakeState {
  const IntakeState();
}

class IntakeInitial extends IntakeState {
  const IntakeInitial();
}

class IntakeLoading extends IntakeState {
  const IntakeLoading();
}

class IntakeLoaded extends IntakeState {
  final List<IntakeTask> tasks;
  final IntakeSummary summary;
  const IntakeLoaded({required this.tasks, required this.summary});
}

class IntakeActionSuccess extends IntakeState {
  final String message;
  const IntakeActionSuccess({required this.message});
}

class IntakeFailure extends IntakeState {
  final String message;
  const IntakeFailure({required this.message});
}
