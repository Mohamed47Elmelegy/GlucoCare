import 'dart:developer' as developer;
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/dose_history.dart';
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
        final result = await remoteDataSource.saveMedication(user.id, model);
        return result.fold(
          (failure) {
            developer.log('Remote sync failed: ${failure.message}');
            return right(null); // Return success anyway as it's saved locally
          },
          (_) => right(null),
        );
      }

      return right(null);
    } catch (e) {
      developer.log('Error adding medication', error: e);
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
        final result = await remoteDataSource.updateMedication(user.id, model);
        return result.fold(
          (failure) {
            developer.log('Remote sync failed: ${failure.message}');
            return right(null);
          },
          (_) => right(null),
        );
      }

      return right(null);
    } catch (e) {
      developer.log('Error updating medication', error: e);
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
        final result = await remoteDataSource.deleteMedication(user.id, id);
        return result.fold(
          (failure) {
            developer.log('Remote sync failed: ${failure.message}');
            return right(null);
          },
          (_) => right(null),
        );
      }

      return right(null);
    } catch (e) {
      developer.log('Error deleting medication', error: e);
      return left(DatabaseFailure('Failed to delete medication: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    try {
      final models = await localDataSource.getMedications();
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      developer.log('Error getting medications', error: e);
      return left(DatabaseFailure('Failed to get medications: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getTodayMedications(DateTime date) async {
    try {
      final allMedsResult = await getMedications();
      return allMedsResult.fold(
        (failure) => left(failure),
        (meds) {
          final todayMeds = meds.where((m) {
            if (!m.isActive) return false;
            if (m.startDate.isAfter(date)) return false;
            final endDate = m.endDate;
            if (endDate != null && endDate.isBefore(date)) return false;
            return true;
          }).toList();
          return right(todayMeds);
        },
      );
    } catch (e) {
      developer.log('Error getting today medications', error: e);
      return left(DatabaseFailure('Failed to get today\'s medications: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> completeMedicationCourse(String id) async {
    try {
      final allMedsResult = await getMedications();
      return await allMedsResult.fold(
        (failure) => left(failure),
        (meds) async {
          final med = meds.firstWhere((m) => m.id == id);
          final updatedMed = med.copyWith(isActive: false);
          return await updateMedication(updatedMed);
        },
      );
    } catch (e) {
      developer.log('Error completing medication course', error: e);
      return left(DatabaseFailure('Failed to complete medication course: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DoseHistory>>> getHistoryForDate(DateTime date) async {
    try {
      final models = await localDataSource.getAllDoseHistory();
      return right(
        models
            .where((m) =>
                m.dateTime.year == date.year &&
                m.dateTime.month == date.month &&
                m.dateTime.day == date.day)
            .map((m) => m.toEntity())
            .toList(),
      );
    } catch (e) {
      developer.log('Error getting history for date', error: e);
      return left(DatabaseFailure('Failed to get history for date: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> recordHistory(DoseHistory history) async {
    try {
      final model = DoseHistoryModel.fromEntity(history);
      await localDataSource.saveDoseHistory(model);
      final user = await authLocalDataSource.getCachedUser();
      if (user != null) {
        await remoteDataSource.saveDoseHistory(user.id, model);
      }
      return right(null);
    } catch (e) {
      developer.log('Error recording history', error: e);
      return left(DatabaseFailure('Failed to record history: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncMedications() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) return left(const AuthFailure('User not logged in'));

      final remoteMedsResult = await remoteDataSource.getMedications(user.id);
       remoteMedsResult.fold(
        (failure) => developer.log('Sync Medications failed: ${failure.message}'),
        (meds) async => await localDataSource.saveAllMedications(meds),
      );

      final remoteHistoryResult = await remoteDataSource.getAllDoseHistory(user.id);
      remoteHistoryResult.fold(
        (failure) => developer.log('Sync History failed: ${failure.message}'),
        (history) async => await localDataSource.saveAllDoseHistories(history),
      );

      return right(null);
    } catch (e) {
      developer.log('Sync failed', error: e);
      return left(DatabaseFailure('Sync failed: $e'));
    }
  }
}
