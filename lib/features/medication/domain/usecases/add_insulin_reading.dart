import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/insulin_reading.dart';
import '../repositories/insulin_repository.dart';

class AddInsulinReading {
  final InsulinRepository repository;

  AddInsulinReading(this.repository);

  Future<Either<Failure, void>> call(InsulinReading reading) async {
    return await repository.addReading(reading);
  }
}
