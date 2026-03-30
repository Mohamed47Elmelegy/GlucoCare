import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../core/widgets/app_background.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_header.dart';
import '../../../../../l10n/app_localizations.dart';

class ForgetPasswordView extends StatefulWidget {
  final bool isLoading;
  final void Function(String email) onResetPassword;

  const ForgetPasswordView({
    super.key,
    required this.isLoading,
    required this.onResetPassword,
  });

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    if (_formKey.currentState!.validate()) {
      widget.onResetPassword(_emailController.text.trim());
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
                  title: l10n.recoveryTitle,
                  subtitle: l10n.recoverySubtitle,
                  icon: PhosphorIcons.key(PhosphorIconsStyle.bold),
                ),
                const SizedBox(height: 40),
                _buildResetForm(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm(AppLocalizations l10n) {
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
                  controller: _emailController,
                  label: l10n.emailLabel,
                  icon: PhosphorIcons.envelopeSimple(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n.enterEmail;
                    if (!value.contains('@')) return l10n.enterValidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                AppButton(
                  text: l10n.sendRecoveryLink,
                  onPressed: _onResetPressed,
                  isLoading: widget.isLoading,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.premiumAqua,
                      AppColors.premiumAqua.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
