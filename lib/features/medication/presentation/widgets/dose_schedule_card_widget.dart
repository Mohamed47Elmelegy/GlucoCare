import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/meal_slot.dart';
import '../utils/medication_ui_labels.dart';

/// Daily dose count (1–3), a time for each dose, and an optional treatment
/// length in days. These values drive the intake tasks and reminders.
class DoseScheduleCardWidget extends StatelessWidget {
  final List<MealSlot> slots;
  final Map<MealSlot, TimeOfDay> doseTimes;
  final TextEditingController durationController;
  final ValueChanged<int> onDoseCountChanged;
  final void Function(MealSlot slot, TimeOfDay time) onDoseTimeChanged;

  const DoseScheduleCardWidget({
    super.key,
    required this.slots,
    required this.doseTimes,
    required this.durationController,
    required this.onDoseCountChanged,
    required this.onDoseTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final doseCount = slots.length;
    final titleStyle = AppTextStyles.h3.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: isDark ? AppColors.darkText : AppColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('عدد المرات يومياً', style: titleStyle),
            _DoseCountStepper(
              count: doseCount,
              onChanged: onDoseCountChanged,
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final slot in slots)
          _DoseTimeRow(
            slot: slot,
            time: doseTimes[slot]!,
            onPicked: (time) => onDoseTimeChanged(slot, time),
          ),
        const SizedBox(height: 4),
        AppTextField(
          controller: durationController,
          label: 'مدة العلاج بالأيام (اتركه فارغاً إذا كان مستمراً)',
          icon: PhosphorIconsRegular.calendarCheck,
          keyboardType: TextInputType.number,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) return null;
            final days = int.tryParse(text);
            if (days == null || days < 1 || days > 3650) {
              return 'أدخل عدد أيام صحيحاً (1 - 3650)';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _DoseCountStepper extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;

  const _DoseCountStepper({required this.count, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final canAdd = count < MealSlot.maxDailyDoses;
    final canRemove = count > 1;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              PhosphorIconsBold.plus,
              size: 16,
              color: canAdd ? AppColors.primary : AppColors.border,
            ),
            onPressed: canAdd ? () => onChanged(count + 1) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$count',
              style: AppTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              PhosphorIconsBold.minus,
              size: 16,
              color: canRemove ? AppColors.textSecondary : AppColors.border,
            ),
            onPressed: canRemove ? () => onChanged(count - 1) : null,
          ),
        ],
      ),
    );
  }
}

class _DoseTimeRow extends StatelessWidget {
  final MealSlot slot;
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onPicked;

  const _DoseTimeRow({
    required this.slot,
    required this.time,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsRegular.clock,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'جرعة ${slot.arabicLabel}',
              style: AppTextStyles.body.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
              );
              if (picked != null) onPicked(picked);
            },
            child: Text(time.format(context)),
          ),
        ],
      ),
    );
  }
}
