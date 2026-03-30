import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';
import '../services/reminder_service_interface.dart';

class AddMedication
    implements UseCase<Either<Failure, void>, AddMedicationParams> {
  final MedicationRepository repository;
  final ReminderServiceInterface reminderService;

  AddMedication(this.repository, this.reminderService);

  @override
  Future<Either<Failure, void>> call(AddMedicationParams params) async {
    final result = await repository.addMedication(params.medication);
    return result.fold((failure) => left(failure), (_) async {
      try {
        await reminderService.scheduleMedicationAlarms(params.medication);
        return right(null);
      } catch (e) {
        // Ideally you'd have a specific failure for notifications
        return left(DatabaseFailure('Failed to schedule alarms: $e'));
      }
    });
  }
}

class AddMedicationParams {
  final Medication medication;

  AddMedicationParams({required this.medication});
}
