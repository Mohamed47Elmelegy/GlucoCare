import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../extensions/context_extension.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showBottomCircle;
  final bool showTopCircle;

  const AppBackground({
    super.key,
    required this.child,
    this.showBottomCircle = true,
    this.showTopCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Stack(
      children: [
        if (showTopCircle)
          PositionedDirectional(
            top: -100,
            end: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.premiumAqua.withValues(
                  alpha: isDark ? 0.15 : 0.08,
                ),
              ),
            ),
          ),
        if (showBottomCircle)
          PositionedDirectional(
            bottom: -150,
            start: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.premiumMint.withValues(
                  alpha: isDark ? 0.1 : 0.05,
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}
