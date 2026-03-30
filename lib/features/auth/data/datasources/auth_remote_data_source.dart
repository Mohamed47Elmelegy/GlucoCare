import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulating a network request delay
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'user@example.com' && password == 'password123') {
      return const UserModel(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
        password: '',
      );
    } else {
      throw const ServerFailure('Invalid email or password');
    }
  }
}
