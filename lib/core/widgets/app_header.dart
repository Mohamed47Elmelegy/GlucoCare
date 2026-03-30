import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../constants/app_colors.dart';

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
    return Column(
      children: [
        if (showLogo)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.premiumGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.premiumMint.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon ?? PhosphorIcons.heartbeat(PhosphorIconsStyle.bold),
              size: 48,
              color: Colors.white,
            ),
          ),
        if (showLogo) const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
