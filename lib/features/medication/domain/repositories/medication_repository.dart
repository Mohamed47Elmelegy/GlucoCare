import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/medication.dart';
import '../entities/dose_history.dart';

abstract class MedicationRepository {
  Future<Either<Failure, void>> addMedication(Medication medication);
  Future<Either<Failure, void>> updateMedication(Medication medication);
  Future<Either<Failure, void>> deleteMedication(String id);
  Future<Either<Failure, List<Medication>>> getMedications();
  Future<Either<Failure, List<DoseHistory>>> getHistoryForDate(DateTime date);
  Future<Either<Failure, void>> recordHistory(DoseHistory history);
  Future<Either<Failure, void>> syncMedications();
}
