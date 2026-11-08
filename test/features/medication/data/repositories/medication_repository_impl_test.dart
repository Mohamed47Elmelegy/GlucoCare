import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/errors/failures.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/models/user_model.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/medication_local_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/datasources/medication_remote_data_source.dart';
import 'package:flutter_test_ai/features/medication/data/models/dose_history_model.dart';
import 'package:flutter_test_ai/features/medication/data/models/medication_model.dart';
import 'package:flutter_test_ai/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class _FakeAuthLocalDataSource implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async =>
      const UserModel(id: 'uid', email: 'user@test.dev', name: 'User', password: '');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeRemoteDataSource implements MedicationRemoteDataSource {
  Either<Failure, List<MedicationModel>> medications = const Right([]);
  Either<Failure, List<DoseHistoryModel>> history = const Right([]);

  @override
  Future<Either<Failure, List<MedicationModel>>> getMedications(String uid) async =>
      medications;

  @override
  Future<Either<Failure, List<DoseHistoryModel>>> getAllDoseHistory(String uid) async =>
      history;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Completes its saves on a later event-loop turn, like real disk I/O, so a
/// caller that doesn't await them returns before they finish.
class _SlowLocalDataSource implements MedicationLocalDataSource {
  bool medicationsSaved = false;
  bool historySaved = false;

  @override
  Future<void> saveAllMedications(List<MedicationModel> medications) async {
    await Future<void>.delayed(Duration.zero);
    medicationsSaved = true;
  }

  @override
  Future<void> saveAllDoseHistories(List<DoseHistoryModel> histories) async {
    await Future<void>.delayed(Duration.zero);
    historySaved = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeRemoteDataSource remote;
  late _SlowLocalDataSource local;
  late MedicationRepositoryImpl repository;

  setUp(() {
    remote = _FakeRemoteDataSource();
    local = _SlowLocalDataSource();
    repository = MedicationRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
      authLocalDataSource: _FakeAuthLocalDataSource(),
    );
  });

  // Regression: the local saves ran un-awaited inside fold().
  test('syncMedications finishes the local saves before reporting success', () async {
    final result = await repository.syncMedications();

    expect(result.isRight(), isTrue);
    expect([local.medicationsSaved, local.historySaved], [true, true]);
  });

  // Regression: a failed download was logged and reported as success.
  test('syncMedications returns the failure when medications cannot be fetched', () async {
    remote.medications = const Left(ServerFailure('offline'));

    final result = await repository.syncMedications();

    expect(result, const Left<Failure, void>(ServerFailure('offline')));
  });

  test('syncMedications returns the failure when dose history cannot be fetched', () async {
    remote.history = const Left(ServerFailure('offline'));

    final result = await repository.syncMedications();

    expect(result, const Left<Failure, void>(ServerFailure('offline')));
  });
}
