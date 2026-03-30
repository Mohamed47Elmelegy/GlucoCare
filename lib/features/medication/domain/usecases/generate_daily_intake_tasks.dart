import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/intake_task.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

class GenerateDailyIntakeTasksUseCase implements UseCase<Either<IntakeFailure, List<IntakeTask>>, DateTime> {
  final IntakeRepository repository;

  GenerateDailyIntakeTasksUseCase(this.repository);

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> call(DateTime params) async {
    return await repository.generateDailyTasks(params);
  }
}
