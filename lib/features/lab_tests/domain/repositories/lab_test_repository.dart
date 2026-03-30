import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lab_test.dart';

abstract class LabTestRepository {
  Future<Either<Failure, List<LabTest>>> getLabTests();
  Future<Either<Failure, void>> addLabTest(LabTest labTest);
  Future<Either<Failure, void>> deleteLabTest(String id);
  Future<Either<Failure, void>> syncLabTests();
}
