import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/lab_test_repository.dart';

class SyncLabTests implements UseCase<Either<Failure, void>, NoParams> {
  final LabTestRepository repository;

  SyncLabTests(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.syncLabTests();
  }
}
