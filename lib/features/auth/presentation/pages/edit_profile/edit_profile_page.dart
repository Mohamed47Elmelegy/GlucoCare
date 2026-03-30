import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/dialog_utils.dart';
import '../../bloc/auth_bloc.dart';
import '../../widgets/profile_section.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      _nameController.text = authState.user.name;
      _emailController.text = authState.user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSaveProfile() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      context.read<AuthBloc>().add(
        UpdateProfileRequested(
          name: name,
          email: email,
          password: password,
        ),
      );
    }
  }

  void _onDeleteAccount() {
    DialogUtils.showConfirmationDialog(
      context: context,
      title: context.l10n.deleteAccount,
      content: context.l10n.confirmLogout, // Replace with proper localization if verify
      confirmText: context.l10n.deleteAccount,
      cancelText: context.l10n.cancel,
      confirmColor: context.colorScheme.error,
      onConfirm: () {
        context.read<AuthBloc>().add(DeleteAccountRequested());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PremiumAppBar(
        leading: IconButton(
          icon: Icon(PhosphorIcons.caretLeft(), color: context.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: context.l10n.accountInformation,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return current is AuthSuccess || current is AuthFailure || current is AuthUnauthenticated;
        },
        listener: (context, state) {
          if (state is AuthUpdateFailure) {
            SnackBarUtils.showError(context, state.errorMessage);
          } else if (state is AuthFailure) {
            SnackBarUtils.showError(context, state.message);
          } else if (state is AuthSuccess) {
            SnackBarUtils.showSuccess(context, context.l10n.profileUpdated);
            context.pop();
          } else if (state is AuthUnauthenticated) {
            SnackBarUtils.showSuccess(context, context.l10n.accountDeleted);
            // Go Router will automatically handle redirecting to login based on router configuration
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return AppBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  children: [
                    ProfileSection(
                      userName: _nameController.text.isNotEmpty ? _nameController.text : 'User',
                      email: _emailController.text.isNotEmpty ? _emailController.text : null,
                    ),
                    const SizedBox(height: 40),
                    _buildEditForm(context),
                    const SizedBox(height: 40),
                    AppButton(
                      text: context.l10n.saveChanges,
                      isLoading: isLoading,
                      onPressed: isLoading ? () {} : _onSaveProfile,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: isLoading ? null : _onDeleteAccount,
                      child: Text(
                        context.l10n.deleteAccount,
                        style: TextStyle(
                          color: isLoading ? context.colorScheme.error.withValues(alpha: 0.5) : context.colorScheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameController,
                  label: context.l10n.fullNameLabel,
                  icon: PhosphorIcons.user(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterFullName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _emailController,
                  label: context.l10n.emailLabel,
                  icon: PhosphorIcons.envelopeSimple(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterEmail;
                    }
                    if (!value.contains('@')) {
                      return context.l10n.enterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _passwordController,
                  label: context.l10n.password,
                  icon: PhosphorIcons.lockSimple(),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterPassword;
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      _obscurePassword
                          ? PhosphorIcons.eyeClosed()
                          : PhosphorIcons.eye(),
                      color: AppColors.premiumMint.withValues(alpha: 0.7),
                      size: 22,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
