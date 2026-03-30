import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insulin_reading.dart';

abstract class InsulinRepository {
  Future<Either<Failure, List<InsulinReading>>> getReadings();
  Future<Either<Failure, void>> addReading(InsulinReading reading);
  Future<Either<Failure, void>> syncReadings();
}
