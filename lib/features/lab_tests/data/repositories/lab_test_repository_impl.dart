import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/lab_test.dart';
import '../../domain/repositories/lab_test_repository.dart';
import '../datasources/lab_test_remote_data_source.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../datasources/lab_test_local_data_source.dart';
import '../models/lab_test_model.dart';

class LabTestRepositoryImpl implements LabTestRepository {
  final LabTestLocalDataSource localDataSource;
  final LabTestRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  LabTestRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<LabTest>>> getLabTests() async {
    try {
      final models = await localDataSource.getLabTests();
      return right(models);
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch lab tests: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addLabTest(LabTest labTest) async {
    try {
      final model = LabTestModel.fromEntity(labTest);

      // 1. Save locally
      await localDataSource.addLabTest(model);

      // 2. Sync to remote
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.addLabTest(user.id, model);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to add lab test: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLabTest(String id) async {
    try {
      // 1. Delete locally
      await localDataSource.deleteLabTest(id);

      // 2. Delete remotely
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.deleteLabTest(user.id, id);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to delete lab test: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncLabTests() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) return left(const AuthFailure('User not logged in'));

      final remoteResult = await remoteDataSource.getLabTests(user.id);
      return await remoteResult.fold((failure) async => left(failure), (
        tests,
      ) async {
        await localDataSource.saveAllTests(tests);
        return right(null);
      });
    } catch (e) {
      return left(DatabaseFailure('Sync failed: $e'));
    }
  }
}
