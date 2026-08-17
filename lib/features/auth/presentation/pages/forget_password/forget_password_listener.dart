import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/auth_cubit.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../l10n/app_localizations.dart';
import 'forget_password_view.dart';

class ForgetPasswordListener extends StatelessWidget {
  const ForgetPasswordListener({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is AuthResetPasswordSuccess) {
          SnackBarUtils.showSuccess(context, l10n.resetLinkSent);
          context.go(RouteConstants.login);
        }
      },
      builder: (context, state) {
        return ForgetPasswordView(
          isLoading: state is AuthLoading,
          onResetPassword: (email) {
            context.read<AuthCubit>().resetPassword(email: email);
          },
        );
      },
    );
  }
}
