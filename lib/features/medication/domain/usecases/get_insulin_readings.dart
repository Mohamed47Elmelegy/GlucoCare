import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insulin_reading.dart';
import '../repositories/insulin_repository.dart';

class GetInsulinReadings {
  final InsulinRepository repository;

  GetInsulinReadings(this.repository);

  Future<Either<Failure, List<InsulinReading>>> call() async {
    return await repository.getReadings();
  }
}
