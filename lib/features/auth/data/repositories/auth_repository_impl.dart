import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test_ai/features/auth/data/datasources/auth_firestore_remote_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:flutter_test_ai/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthRemoteDataSource remoteDataSource;
  final AuthFirestoreRemoteDataSource firestoreRemoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.firestoreRemoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await remoteDataSource.login(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return Left(ServerFailure('User is null after login'));
      }

      // Try fetching user data from Firestore
      final firestoreResult = await firestoreRemoteDataSource.getUserData(
        userCredential.user!.uid,
      );

      UserModel userModel;
      if (firestoreResult.isRight()) {
        userModel = firestoreResult.getOrElse(
          (_) => throw Exception('Should not happen'),
        );
      } else {
        // If not found in Firestore (e.g. migration), create it from Firebase Auth data
        userModel = UserModel.fromFirebase(userCredential.user!);
        await firestoreRemoteDataSource.saveUserData(userModel);
      }

      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Authentication error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        return Left(ServerFailure('User is null after registration'));
      }
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        password: '',
      );

      // Save user data to Firestore
      await firestoreRemoteDataSource.saveUserData(userModel);

      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await remoteDataSource.resetPassword(email: email);
      return const Right(null);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Reset password error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // 1. Check local cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // 2. If not in cache, check if logged into Firebase Auth
      final firebaseUser = remoteDataSource.getCurrentUser();
      if (firebaseUser != null) {
        // Try fetching full profile from Firestore
        final firestoreResult = await firestoreRemoteDataSource.getUserData(
          firebaseUser.uid,
        );

        UserModel userModel;
        if (firestoreResult.isRight()) {
          userModel = firestoreResult.getOrElse(
            (_) => throw Exception('Should not happen'),
          );
        } else {
          // If not in Firestore (e.g. migration or edge case), fallback to Firebase Auth data
          userModel = UserModel.fromFirebase(firebaseUser);
          await firestoreRemoteDataSource.saveUserData(userModel);
        }

        // Cache the fetched user
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final currentUserResult = await getCurrentUser();
      if (currentUserResult.isLeft()) {
        return Left(currentUserResult.getLeft().toNullable()!);
      }

      final currentUser = currentUserResult.getRight().toNullable();
      if (currentUser == null) {
        return const Left(ServerFailure('User not logged in'));
      }

      await remoteDataSource.updateProfile(name: name, email: email, password: password);

      final updatedUserModel = UserModel(
        id: currentUser.id,
        email: email,
        name: name,
        password: '', // We don't store plain password
      );

      await firestoreRemoteDataSource.saveUserData(updatedUserModel);
      await localDataSource.cacheUser(updatedUserModel);

      return Right(updatedUserModel);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Update profile error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final currentUserResult = await getCurrentUser();
      if (currentUserResult.isLeft()) {
        return Left(currentUserResult.getLeft().toNullable()!);
      }
      final currentUser = currentUserResult.getRight().toNullable();

      if (currentUser != null) {
        // First delete from Firestore
        await firestoreRemoteDataSource.deleteUserData(currentUser.id);
      }

      await remoteDataSource.deleteAccount();
      await localDataSource.clearCache();
      
      return const Right(null);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Delete account error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
