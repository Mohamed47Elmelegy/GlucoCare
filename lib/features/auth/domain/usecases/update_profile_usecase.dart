import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateProfileParams {
  final String name;
  final String email;
  final String password;

  UpdateProfileParams({required this.name, required this.email, required this.password});
}

class UpdateProfileUseCase implements UseCase<Either<Failure, User>, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
