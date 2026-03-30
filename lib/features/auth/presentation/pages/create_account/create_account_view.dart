import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';
import '../../../../../l10n/app_localizations.dart';

class CreateAccountView extends StatefulWidget {
  final bool isLoading;
  final void Function(String name, String email, String password) onCreateAccount;
  final VoidCallback onBackToLogin;

  const CreateAccountView({
    super.key,
    required this.isLoading,
    required this.onCreateAccount,
    required this.onBackToLogin,
  });

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    if (_formKey.currentState!.validate()) {
      widget.onCreateAccount(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppHeader(
                  title: l10n.joinTitle,
                  subtitle: l10n.joinSubtitle,
                  showLogo: false,
                ),
                const SizedBox(height: 40),
                _buildRegisterForm(l10n),
                const SizedBox(height: 24),
                _buildFooter(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(AppLocalizations l10n) {
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
                  label: l10n.fullNameLabel,
                  icon: PhosphorIcons.user(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enterFullName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _emailController,
                  label: l10n.emailLabel,
                  icon: PhosphorIcons.envelopeSimple(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enterEmail;
                    }
                    if (!value.contains('@')) {
                      return l10n.enterValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _passwordController,
                  label: l10n.passwordLabel,
                  icon: PhosphorIcons.lockSimple(),
                  obscureText: _obscurePassword,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.enterPassword;
                    }
                    if (value.length < 6) {
                      return l10n.minPasswordLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: l10n.createAccountButton,
                  onPressed: _onCreateAccount,
                  isLoading: widget.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        GestureDetector(
          onTap: widget.onBackToLogin,
          child: Text(
            l10n.loginButton,
            style: const TextStyle(
              color: AppColors.premiumMint,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
