import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../cubit/auth_cubit.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../l10n/app_localizations.dart';
import 'create_account_view.dart';

class CreateAccountListener extends StatelessWidget {
  const CreateAccountListener({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          SnackBarUtils.showError(context, state.message);
        } else if (state is AuthAuthenticated) {
          SnackBarUtils.showSuccess(context, l10n.accountCreated);
          context.read<AuthCubit>().logout();
        }
      },
      builder: (context, state) {
        return CreateAccountView(
          isLoading: state is AuthLoading,
          onCreateAccount: (name, email, password) {
            context.read<AuthCubit>().register(
              name: name,
              email: email,
              password: password,
            );
          },
          onBackToLogin: () {
            context.go(RouteConstants.login);
          },
        );
      },
    );
  }
}
