import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/medication_repository.dart';
import '../services/reminder_service_interface.dart';

class DeleteMedication
    implements UseCase<Either<Failure, void>, DeleteMedicationParams> {
  final MedicationRepository repository;
  final ReminderServiceInterface reminderService;

  DeleteMedication(this.repository, this.reminderService);

  @override
  Future<Either<Failure, void>> call(DeleteMedicationParams params) async {
    final result = await repository.deleteMedication(params.id);
    return result.fold((failure) => left(failure), (_) async {
      try {
        await reminderService.cancelMedicationAlarms(params.id);
        return right(null);
      } catch (e) {
        return left(DatabaseFailure('Failed to cancel alarms: $e'));
      }
    });
  }
}

class DeleteMedicationParams {
  final String id;

  DeleteMedicationParams({required this.id});
}
