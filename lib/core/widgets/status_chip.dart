import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum StatusType { success, error, info }

class StatusChip extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusChip({super.key, required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case StatusType.success:
        backgroundColor = AppColors.statusTakenBg;
        textColor = AppColors.statusTakenText;
        break;
      case StatusType.error:
        backgroundColor = AppColors.statusMissedBg;
        textColor = AppColors.statusMissedText;
        break;
      case StatusType.info:
        backgroundColor = AppColors.statusUpcomingBg;
        textColor = AppColors.statusUpcomingText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
