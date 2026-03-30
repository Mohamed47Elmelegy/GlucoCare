import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';

class SettingsListItem extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? titleColor;

  const SettingsListItem({
    super.key,
    this.icon,
    this.assetPath,
    required this.title,
    required this.onTap,
    this.trailing,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (titleColor ?? colorScheme.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: assetPath != null
            ? Image.asset(assetPath!, width: 24, height: 24)
            : Icon(
                icon,
                color: titleColor ?? colorScheme.primary,
              ),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
