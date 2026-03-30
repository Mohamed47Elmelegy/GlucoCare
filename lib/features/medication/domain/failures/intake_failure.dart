import '../../../../core/errors/failures.dart';

sealed class IntakeFailure extends Failure {
  const IntakeFailure(super.message);
}

class IntakeTaskNotFoundFailure extends IntakeFailure {
  const IntakeTaskNotFoundFailure() : super('Intake task not found');
}

class IntakeGenerationFailure extends IntakeFailure {
  const IntakeGenerationFailure(super.message);
}

class IntakeUpdateFailure extends IntakeFailure {
  const IntakeUpdateFailure(super.message);
}

class IntakeStorageFailure extends IntakeFailure {
  const IntakeStorageFailure(super.message);
}
