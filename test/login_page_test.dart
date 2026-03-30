import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_ai/features/auth/presentation/pages/login/login_page.dart';
import 'package:flutter_test_ai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_test_ai/core/errors/failures.dart';
import 'package:flutter_test_ai/features/auth/domain/entities/user.dart';
import 'package:flutter_test_ai/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test_ai/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:flutter_test_ai/l10n/app_localizations.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test_ai/core/usecases/usecase.dart';

// Simple fakes for tests
class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async => const Right(User(id: '1', email: 't@t.com', name: 'T'));
  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async => const Right(User(id: '1', email: 't@t.com', name: 'T'));
  @override
  Future<Either<Failure, void>> logout() async => const Right(null);
  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async =>
      const Right(null);
  @override
  Future<Either<Failure, User?>> getCurrentUser() async => const Right(null);

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    required String email,
    required String password,
  }) async => const Right(User(id: '1', email: 't@t.com', name: 'T'));

  @override
  Future<Either<Failure, void>> deleteAccount() async => const Right(null);
}

class FakeLoginUseCase extends LoginUseCase {
  FakeLoginUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, User>> call(LoginParams params) async =>
      const Right(User(id: '1', email: 't@t.com', name: 'T'));
}

class FakeRegisterUseCase extends RegisterUseCase {
  FakeRegisterUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async =>
      const Right(User(id: '1', email: 't@t.com', name: 'T'));
}

class FakeLogoutUseCase extends LogoutUseCase {
  FakeLogoutUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, void>> call(NoParams params) async =>
      const Right(null);
}

class FakeResetPasswordUseCase extends ResetPasswordUseCase {
  FakeResetPasswordUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, void>> call(String email) async => const Right(null);
}

class FakeGetCurrentUserUseCase extends GetCurrentUserUseCase {
  FakeGetCurrentUserUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, User?>> call(NoParams params) async =>
      const Right(null);
}
class FakeUpdateProfileUseCase extends UpdateProfileUseCase {
  FakeUpdateProfileUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, User>> call(UpdateProfileParams params) async =>
      const Right(User(id: '1', email: 't@t.com', name: 'T'));
}

class FakeDeleteAccountUseCase extends DeleteAccountUseCase {
  FakeDeleteAccountUseCase() : super(FakeAuthRepository());
  @override
  Future<Either<Failure, void>> call(NoParams params) async =>
      const Right(null);
}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(
      loginUseCase: FakeLoginUseCase(),
      registerUseCase: FakeRegisterUseCase(),
      logoutUseCase: FakeLogoutUseCase(),
      resetPasswordUseCase: FakeResetPasswordUseCase(),
      getCurrentUserUseCase: FakeGetCurrentUserUseCase(),
      updateProfileUseCase: FakeUpdateProfileUseCase(),
      deleteAccountUseCase: FakeDeleteAccountUseCase(),
    );
  });

  tearDown(() {
    authBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage has Email and Password fields, and a Login button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
