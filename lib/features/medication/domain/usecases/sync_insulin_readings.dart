import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/insulin_repository.dart';

class SyncInsulinReadings implements UseCase<Either<Failure, void>, NoParams> {
  final InsulinRepository repository;

  SyncInsulinReadings(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.syncReadings();
  }
}
