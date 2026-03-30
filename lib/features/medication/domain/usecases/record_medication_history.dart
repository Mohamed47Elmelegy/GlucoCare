import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dose_history.dart';
import '../repositories/medication_repository.dart';

class RecordMedicationHistory {
  final MedicationRepository repository;

  RecordMedicationHistory(this.repository);

  Future<Either<Failure, void>> call(DoseHistory history) async {
    return await repository.recordHistory(history);
  }
}
