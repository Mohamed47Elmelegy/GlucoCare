import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';

class PremiumActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final String statusText;
  final VoidCallback? onAction;

  const PremiumActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isActive = false,
    required this.statusText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAction,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isActive ? null : context.colorScheme.surfaceContainerHighest.withValues(alpha: context.isDark ? 1.0 : 0.5),
        gradient: isActive ? AppColors.premiumGradient : null,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.black.withValues(alpha: 0.05)
                      : context.colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isActive ? Colors.black87 : context.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 28,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  color: isActive ? Colors.black87 : context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isActive ? Colors.black54 : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: context.textTheme.labelSmall?.copyWith(
                  color: isActive ? Colors.black54 : context.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Colors.black.withValues(alpha: 0.1)
                      : context.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
                child: Icon(
                  PhosphorIcons.plus(PhosphorIconsStyle.bold),
                  color: isActive ? Colors.black : context.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
