import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'auth_state.dart';

export 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    final result = await _getCurrentUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(const AuthLoading());
    final result = await _resetPasswordUseCase(email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthResetPasswordSuccess()),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    User? currentUser;
    if (state is AuthAuthenticated) {
      currentUser = (state as AuthAuthenticated).user;
    }

    emit(const AuthLoading());
    final result = await _updateProfileUseCase(
      UpdateProfileParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) {
        if (currentUser != null) {
          emit(AuthUpdateError(currentUser, failure.message));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    final result = await _deleteAccountUseCase(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
