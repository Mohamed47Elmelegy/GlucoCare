import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../extensions/context_extension.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Color? iconColor;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyLarge.copyWith(
              color: context.colorScheme.onSurface,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: '$label...',
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              prefixIcon: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 20,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.colorScheme.error.withValues(alpha: 0.5)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: context.colorScheme.error, width: 1.5),
              ),
            ),
            validator: validator,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
