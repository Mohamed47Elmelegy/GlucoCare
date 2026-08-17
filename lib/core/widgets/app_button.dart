import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;
  final bool isDanger;
  final bool isOutline; // Restored for compatibility
  final LinearGradient? gradient; // Restored for compatibility
  final List<BoxShadow>? boxShadow; // Restored for compatibility
  final double? width;
  final double height;
  final double fontSize;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.isDanger = false,
    this.isOutline = false,
    this.gradient,
    this.boxShadow,
    this.width,
    this.height = 52,
    this.fontSize = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool effectiveSecondary = isSecondary || isOutline;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: effectiveSecondary
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: padding,
              ),
              child: _buildChild(context, AppColors.primary),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger ? AppColors.danger : AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: padding,
              ),
              child: _buildChild(context, AppColors.onPrimary),
            ),
    );
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
