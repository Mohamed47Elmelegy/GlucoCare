import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> resetPassword({required String email});

  Future<void> updateProfile({required String name, required String email, required String password});

  Future<void> deleteAccount();

  User? getCurrentUser();
}

class FirebaseAuthRemoteDataSourceImpl implements FirebaseAuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await userCredential.user?.updateDisplayName(name);
    return userCredential;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  @override
  Future<void> updateProfile({required String name, required String email, required String password}) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: password);
      await user.reauthenticateWithCredential(credential);

      await user.updateDisplayName(name);
      if (user.email != email) {
        await user.verifyBeforeUpdateEmail(email);
      }
    } else {
      throw Exception('No user found to update');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw Exception('No user found to delete');
    }
  }
}
