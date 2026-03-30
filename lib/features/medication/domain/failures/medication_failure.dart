import '../../../../core/errors/failures.dart';

sealed class MedicationFailure extends Failure {
  const MedicationFailure(super.message);
}

class MedicationNotFoundFailure extends MedicationFailure {
  const MedicationNotFoundFailure() : super('Medication not found');
}

class MedicationSaveFailure extends MedicationFailure {
  const MedicationSaveFailure(super.message);
}

class MedicationValidationFailure extends MedicationFailure {
  const MedicationValidationFailure(super.message);
}

class MedicationSyncFailure extends MedicationFailure {
  const MedicationSyncFailure(super.message);
}
