import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/medication_type.dart';
import '../utils/medication_ui_labels.dart';

/// Single-choice chips for the medication form (pill, injection, ...).
class MedicationTypeSelectorWidget extends StatelessWidget {
  final MedicationType selected;
  final ValueChanged<MedicationType> onChanged;

  const MedicationTypeSelectorWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الدواء',
          style: AppTextStyles.h3.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            for (final type in MedicationType.values)
              ChoiceChip(
                label: Text(type.arabicLabel),
                selected: type == selected,
                onSelected: (isSelected) {
                  if (isSelected) onChanged(type);
                },
                selectedColor: AppColors.primary,
                backgroundColor:
                    isDark ? AppColors.darkBackground : AppColors.background,
                labelStyle: TextStyle(
                  color: type == selected
                      ? Colors.white
                      : (isDark ? AppColors.darkText : AppColors.textPrimary),
                  fontWeight:
                      type == selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: type == selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                showCheckmark: false,
              ),
          ],
        ),
      ],
    );
  }
}
