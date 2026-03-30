import 'package:fpdart/fpdart.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/intake_task.dart';
import '../failures/intake_failure.dart';
import '../repositories/intake_repository.dart';

class GetTodayIntakeTasksUseCase implements UseCase<Either<IntakeFailure, List<IntakeTask>>, NoParams> {
  final IntakeRepository repository;

  GetTodayIntakeTasksUseCase(this.repository);

  @override
  Future<Either<IntakeFailure, List<IntakeTask>>> call(NoParams params) async {
    return await repository.getTasksForDate(DateTime.now());
  }
}
