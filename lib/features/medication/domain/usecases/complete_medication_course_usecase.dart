import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/medication_repository.dart';

class CompleteMedicationCourseUseCase implements UseCase<Either<Failure, void>, String> {
  final MedicationRepository repository;

  CompleteMedicationCourseUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.completeMedicationCourse(id);
  }
}
