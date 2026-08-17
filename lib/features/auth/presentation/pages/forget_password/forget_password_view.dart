import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/widgets/app_text_field.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppHeader(
                  title: 'صحتي',
                  subtitle: l10n.recoverySubtitle,
                  icon: PhosphorIconsFill.key,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.recoveryTitle,
                          style: AppTextStyles.h2.copyWith(
                            color: isDark ? AppColors.darkText : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.recoverySubtitle,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          controller: _emailController,
                          label: l10n.emailLabel,
                          icon: PhosphorIconsRegular.envelopeSimple,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) return l10n.enterEmail;
                            if (!value.contains('@')) return l10n.enterValidEmail;
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        AppButton(
                          text: l10n.sendRecoveryLink,
                          onPressed: _onResetPressed,
                          isLoading: widget.isLoading,
                        ),
                      ],
                    ),
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
