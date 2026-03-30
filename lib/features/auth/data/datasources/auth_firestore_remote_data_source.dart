import 'package:fpdart/fpdart.dart';
import '../../../../core/data/datasources/base_firestore_remote_data_source.dart';
import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class AuthFirestoreRemoteDataSource {
  Future<Either<Failure, Unit>> saveUserData(UserModel user);
  Future<Either<Failure, UserModel>> getUserData(String uid);
  Future<Either<Failure, Unit>> deleteUserData(String uid);
}

class AuthFirestoreRemoteDataSourceImpl
    extends BaseFirestoreRemoteDataSource<UserModel>
    implements AuthFirestoreRemoteDataSource {
  AuthFirestoreRemoteDataSourceImpl({required super.firestoreService});

  @override
  String get collectionPath => 'users';

  @override
  UserModel fromFirestore(Map<String, dynamic> json) =>
      UserModel.fromFirestore(json);

  @override
  Map<String, dynamic> toFirestore(UserModel model) => model.toFirestore();

  @override
  Future<Either<Failure, Unit>> saveUserData(UserModel user) {
    return save(user.id, user);
  }

  @override
  Future<Either<Failure, UserModel>> getUserData(String uid) {
    return getById(uid);
  }

  @override
  Future<Either<Failure, Unit>> deleteUserData(String uid) {
    return remove(uid);
  }
}
