import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class AddMedicationUseCase implements UseCase<Either<Failure, void>, Medication> {
  final MedicationRepository repository;

  AddMedicationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Medication medication) async {
    return await repository.addMedication(medication);
  }
}
