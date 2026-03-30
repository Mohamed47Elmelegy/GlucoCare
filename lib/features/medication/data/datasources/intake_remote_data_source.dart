import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/intake_task_model.dart';

abstract class IntakeRemoteDataSource {
  Future<Either<Failure, List<IntakeTaskModel>>> getIntakeTasks(String uid);
  Future<Either<Failure, Unit>> saveIntakeTask(String uid, IntakeTaskModel task);
  Future<Either<Failure, Unit>> saveAllIntakeTasks(String uid, List<IntakeTaskModel> tasks);
  Future<Either<Failure, Unit>> updateIntakeTask(String uid, IntakeTaskModel task);
}

class IntakeRemoteDataSourceImpl implements IntakeRemoteDataSource {
  final FirestoreService firestoreService;

  IntakeRemoteDataSourceImpl({required this.firestoreService});

  String _intakePath(String uid) => 'users/$uid/intake_tasks';

  @override
  Future<Either<Failure, List<IntakeTaskModel>>> getIntakeTasks(String uid) {
    return firestoreService.getAll<IntakeTaskModel>(
      collectionPath: _intakePath(uid),
      fromFirestore: (map) => IntakeTaskModel.fromJson(map),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveIntakeTask(String uid, IntakeTaskModel task) {
    return firestoreService.set(
      collectionPath: _intakePath(uid),
      docId: task.id,
      data: task.toJson(),
    );
  }

  @override
  Future<Either<Failure, Unit>> saveAllIntakeTasks(String uid, List<IntakeTaskModel> tasks) async {
    for (var task in tasks) {
      final res = await saveIntakeTask(uid, task);
      if (res.isLeft()) return res;
    }
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateIntakeTask(String uid, IntakeTaskModel task) {
    return saveIntakeTask(uid, task);
  }
}
