import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/routes/route_constants.dart';

/// Top-bar button that opens Settings (account, language, theme, logout).
class DashboardSettingsButton extends StatelessWidget {
  const DashboardSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsetsDirectional.only(end: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        tooltip: 'الإعدادات',
        icon: const Icon(
          PhosphorIconsBold.gear,
          size: 20,
          color: AppColors.textSecondary,
        ),
        onPressed: () => context.push(RouteConstants.settings),
      ),
    );
  }
}
