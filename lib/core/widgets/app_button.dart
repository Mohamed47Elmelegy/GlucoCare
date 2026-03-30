import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final LinearGradient? gradient;
  final List<BoxShadow>? boxShadow;
  final double fontSize;
  final EdgeInsets padding;

  final bool isSecondary;
  final bool isOutline;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.boxShadow,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(vertical: 18),
    this.isSecondary = false,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.premiumMint),
      );
    }

    final colorScheme = context.colorScheme;

    if (isOutline) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(color: colorScheme.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isSecondary ? null : (gradient ?? AppColors.premiumGradient),
        color: isSecondary ? colorScheme.secondaryContainer : null,
        boxShadow: isSecondary
            ? null
            : (boxShadow ??
                  [
                    BoxShadow(
                      color: (gradient?.colors.first ?? AppColors.premiumMint)
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isSecondary
                ? colorScheme.onSecondaryContainer
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
