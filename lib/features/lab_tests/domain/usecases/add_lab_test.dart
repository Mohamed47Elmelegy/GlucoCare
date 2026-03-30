import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lab_test.dart';
import '../repositories/lab_test_repository.dart';

class AddLabTest implements UseCase<Either<Failure, void>, LabTest> {
  final LabTestRepository repository;

  AddLabTest(this.repository);

  @override
  Future<Either<Failure, void>> call(LabTest labTest) async {
    return await repository.addLabTest(labTest);
  }
}
