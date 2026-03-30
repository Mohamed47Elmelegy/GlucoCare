import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/intake_task.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

/// UseCase to get filtered intake tasks for a specific medication.
/// Encapsulates the business logic: "Fetching and filtering tasks by medicationId".
class GetMedicationTasksUseCase implements UseCase<Either<IntakeFailure, List<IntakeTask>>, GetMedicationTasksParams> {
  final IntakeRepository repository;

  GetMedicationTasksUseCase(this.repository);

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> call(GetMedicationTasksParams params) async {
    final result = await repository.getTasksForDate(params.date);
    
    return result.map((tasks) {
      return tasks.where((task) => task.medicationId == params.medicationId).toList();
    });
  }
}

class GetMedicationTasksParams {
  final DateTime date;
  final String medicationId;

  const GetMedicationTasksParams({
    required this.date,
    required this.medicationId,
  });
}
