import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';
import '../services/reminder_service_interface.dart';

class UpdateMedication
    implements UseCase<Either<Failure, void>, UpdateMedicationParams> {
  final MedicationRepository repository;
  final ReminderServiceInterface reminderService;

  UpdateMedication(this.repository, this.reminderService);

  @override
  Future<Either<Failure, void>> call(UpdateMedicationParams params) async {
    final result = await repository.updateMedication(params.medication);
    return result.fold((failure) => left(failure), (_) async {
      try {
        await reminderService.cancelMedicationAlarms(params.medication.id);
        await reminderService.scheduleMedicationAlarms(params.medication);
        return right(null);
      } catch (e) {
        return left(DatabaseFailure('Failed to update scheduled alarms: $e'));
      }
    });
  }
}

class UpdateMedicationParams {
  final Medication medication;

  UpdateMedicationParams({required this.medication});
}
