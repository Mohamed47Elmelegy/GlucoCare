import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

class GetTodayMedicationsUseCase implements UseCase<Either<Failure, List<Medication>>, DateTime> {
  final MedicationRepository repository;

  GetTodayMedicationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Medication>>> call(DateTime date) async {
    return await repository.getTodayMedications(date);
  }
}
