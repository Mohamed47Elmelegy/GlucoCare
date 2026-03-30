import '../../domain/entities/dose_history.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medication_remote_data_source.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../datasources/medication_local_data_source.dart';
import '../models/medication_model.dart';
import '../models/dose_history_model.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationLocalDataSource localDataSource;
  final MedicationRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  MedicationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> addMedication(Medication medication) async {
    try {
      final model = MedicationModel.fromEntity(medication);

      // 1. Save locally
      await localDataSource.saveMedication(model);

      // 2. Sync to remote
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.saveMedication(user.id, model);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to add medication: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMedication(Medication medication) async {
    try {
      final model = MedicationModel.fromEntity(medication);

      // 1. Update locally
      await localDataSource.updateMedication(model);

      // 2. Sync to remote
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.updateMedication(user.id, model);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to update medication: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedication(String id) async {
    try {
      // 1. Delete locally
      await localDataSource.deleteMedication(id);

      // 2. Sync to remote
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.deleteMedication(user.id, id);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to delete medication: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    try {
      final models = await localDataSource.getMedications();
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return left(DatabaseFailure('Failed to get medications: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DoseHistory>>> getHistoryForDate(
    DateTime date,
  ) async {
    try {
      // For now, we get all history and filter by date.
      // In a real app, this should be done at the database query level.
      final models = await localDataSource.getDoseHistory(
        '',
      ); // Empty string for all, or filter needed
      return right(
        models
            .where(
              (m) =>
                  m.dateTime.year == date.year &&
                  m.dateTime.month == date.month &&
                  m.dateTime.day == date.day,
            )
            .map((m) => m.toEntity())
            .toList(),
      );
    } catch (e) {
      return left(DatabaseFailure('Failed to get history for date: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> recordHistory(DoseHistory history) async {
    try {
      final model = DoseHistoryModel.fromEntity(history);

      // 1. Save locally
      await localDataSource.saveDoseHistory(model);

      // 2. Sync to remote
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.saveDoseHistory(user.id, model);
      }

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Failed to record history: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncMedications() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) return left(const AuthFailure('User not logged in'));

      // 1. Sync Medications
      final remoteMedsResult = await remoteDataSource.getMedications(user.id);
      await remoteMedsResult.fold(
        (failure) => null,
        (meds) async => await localDataSource.saveAllMedications(meds),
      );

      // 2. Sync Dose History
      final remoteHistoryResult = await remoteDataSource.getAllDoseHistory(
        user.id,
      );
      await remoteHistoryResult.fold(
        (failure) => null,
        (history) async => await localDataSource.saveAllDoseHistories(history),
      );

      return right(null);
    } catch (e) {
      return left(DatabaseFailure('Sync failed: $e'));
    }
  }
}
