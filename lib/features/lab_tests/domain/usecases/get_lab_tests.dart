import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/lab_test.dart';
import '../repositories/lab_test_repository.dart';

class GetLabTests implements UseCase<Either<Failure, List<LabTest>>, NoParams> {
  final LabTestRepository repository;

  GetLabTests(this.repository);

  @override
  Future<Either<Failure, List<LabTest>>> call(NoParams params) async {
    return await repository.getLabTests();
  }
}
