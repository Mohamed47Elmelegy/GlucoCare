import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth_bloc.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../l10n/app_localizations.dart';
import 'login_view.dart';

class LoginListener extends StatelessWidget {
  const LoginListener({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is AuthSuccess) {
          SnackBarUtils.showSuccess(
            context,
            l10n.welcomeBack(state.user.name),
          );
          context.go(RouteConstants.home);
        } else if (state is AuthResetPasswordSuccess) {
          SnackBarUtils.showSuccess(context, l10n.resetEmailSent);
        }
      },
      builder: (context, state) {
        return LoginView(
          isLoading: state is AuthLoading,
          onLogin: (email, password) {
            context.read<AuthBloc>().add(
              LoginRequested(email: email, password: password),
            );
          },
          onForgotPassword: () {
            context.push(RouteConstants.forgetPassword);
          },
          onSignUp: () {
            context.push(RouteConstants.createAccount);
          },
        );
      },
    );
  }
}
