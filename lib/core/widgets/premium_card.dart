import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool glassmorphic;
  final Color? color;
  final Gradient? gradient;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.glassmorphic = false,
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isDark = context.isDark;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            color ??
            (glassmorphic
                ? colorScheme.surface.withValues(
                    alpha: isDark ? 0.7 : 0.1,
                  )
                : AppColors.surface),
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.textBlack.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (glassmorphic) {
      return Container(
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: content,
          ),
        ),
      );
    }

    return Container(margin: margin, child: content);
  }
}
