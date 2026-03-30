import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/insulin_reading.dart';
import '../../domain/repositories/insulin_repository.dart';
import '../datasources/insulin_remote_data_source.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../datasources/insulin_local_data_source.dart';
import '../models/insulin_reading_model.dart';

class InsulinRepositoryImpl implements InsulinRepository {
  final InsulinLocalDataSource localDataSource;
  final InsulinRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  InsulinRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, List<InsulinReading>>> getReadings() async {
    try {
      final models = await localDataSource.getReadings();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(CacheFailure('Failed to fetch insulin readings'));
    }
  }

  @override
  Future<Either<Failure, void>> addReading(InsulinReading reading) async {
    try {
      final model = InsulinReadingModel.fromEntity(reading);

      // 1. Save locally
      await localDataSource.addReading(model);

      // 2. Try to sync to remote if user is logged in
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.addReading(user.id, model);
      }

      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure('Failed to save insulin reading'));
    }
  }

  @override
  Future<Either<Failure, void>> syncReadings() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) return const Left(AuthFailure('User not logged in'));

      final remoteResult = await remoteDataSource.getReadings(user.id);
      return await remoteResult.fold((failure) async => Left(failure), (
        readings,
      ) async {
        await localDataSource.saveAllReadings(readings);
        return const Right(null);
      });
    } catch (e) {
      return Left(DatabaseFailure('Sync failed: $e'));
    }
  }
}
