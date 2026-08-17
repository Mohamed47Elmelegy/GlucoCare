import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final bool showLogo;

  const AppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        if (showLogo)
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon ?? PhosphorIconsFill.pill,
                size: 38,
                color: Colors.white,
              ),
            ),
          ),
        if (showLogo) const SizedBox(height: 20),
        Text(
          title,
          style: AppTextStyles.h1.copyWith(
            color: AppColors.primary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: AppTextStyles.body.copyWith(
            color: isDark ? AppColors.darkText.withValues(alpha: 0.7) : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

