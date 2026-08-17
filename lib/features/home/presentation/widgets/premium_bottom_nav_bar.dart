import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class PremiumBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PremiumBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    title: 'الرئيسية',
                    icon: PhosphorIconsRegular.squaresFour,
                    activeIcon: PhosphorIconsFill.squaresFour,
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavBarItem(
                    title: 'الأدوية',
                    icon: PhosphorIconsRegular.pill,
                    activeIcon: PhosphorIconsFill.pill,
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  _NavBarItem(
                    title: 'الأنسولين',
                    icon: PhosphorIconsRegular.drop,
                    activeIcon: PhosphorIconsFill.drop,
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _NavBarItem(
                    title: 'المواعيد',
                    icon: PhosphorIconsRegular.calendarBlank,
                    activeIcon: PhosphorIconsFill.calendarBlank,
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavBarItem(
                    title: 'الملف',
                    icon: PhosphorIconsRegular.folder,
                    activeIcon: PhosphorIconsFill.folder,
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkText.withValues(alpha: 0.4) : AppColors.textSecondary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: AnimatedScale(
            scale: isSelected ? 1.04 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? activeColor : inactiveColor,
                    height: 1.1,
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
