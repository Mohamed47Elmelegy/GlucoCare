import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/extensions/context_extension.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final VoidCallback onPickTime;

  const TimePickerField({
    super.key,
    required this.selectedTime,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(
          alpha: isDark ? 0.1 : 0.2,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.scheduleTime,
                  style: textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.premiumMint : colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedTime == null
                      ? l10n.noTimeSelected
                      : selectedTime!.format(context),
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onPickTime,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.premiumMint
                  : colorScheme.primary,
              foregroundColor: isDark ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.pickTime),
          ),
        ],
      ),
    );
  }
}
