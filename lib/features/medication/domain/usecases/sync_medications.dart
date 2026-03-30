import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/medication_repository.dart';

class SyncMedications implements UseCase<Either<Failure, void>, NoParams> {
  final MedicationRepository repository;

  SyncMedications(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.syncMedications();
  }
}
