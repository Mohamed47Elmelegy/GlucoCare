import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class UpdateMedicationUseCase implements UseCase<Either<Failure, void>, Medication> {
  final MedicationRepository repository;

  UpdateMedicationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Medication medication) async {
    return await repository.updateMedication(medication);
  }
}
