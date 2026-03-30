import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/dose_history.dart';
import '../repositories/medication_repository.dart';

class GetHistoryForDate {
  final MedicationRepository repository;

  GetHistoryForDate(this.repository);

  Future<Either<Failure, List<DoseHistory>>> call(DateTime date) async {
    return await repository.getHistoryForDate(date);
  }
}
