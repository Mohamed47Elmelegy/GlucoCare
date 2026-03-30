import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/medication_timeline_item.dart';
import '../../../../core/extensions/context_extension.dart';

class PremiumMedicationTimeline extends StatelessWidget {
  final List<MedicationTimelineItem> items;

  const PremiumMedicationTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            AppStrings.dailyRoutine,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildTimelineItem(context, items[i]),
                if (i < items.length - 1)
                  Expanded(child: _buildConnector(context, items[i].status)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, MedicationTimelineItem item) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    bool isDone = item.status == TimelineStatus.done;
    bool isNext = item.status == TimelineStatus.next;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColors.premiumMint
                : isNext
                ? AppColors.premiumMint.withValues(alpha: 0.2)
                : colorScheme.surfaceContainerHighest,
            border: isNext
                ? Border.all(color: AppColors.premiumMint, width: 2)
                : null,
          ),
          child: Icon(
            isDone ? PhosphorIcons.check(PhosphorIconsStyle.bold) : item.icon,
            color: isDone
                ? Colors.black87
                : isNext
                ? AppColors.premiumMint
                : colorScheme.onSurface.withValues(alpha: 0.38),
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          style: textTheme.labelSmall?.copyWith(
            color: isDone || isNext
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.38),
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.time,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: isNext
                ? AppColors.premiumMint.withValues(alpha: 0.8)
                : colorScheme.onSurface.withValues(alpha: 0.24),
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context, TimelineStatus status) {
    final colorScheme = context.colorScheme;
    return Column(
      children: [
        const SizedBox(
          height: 23,
        ), // Half of icon height (48/2) - half of connector height (2/2)
        Container(
          height: 2,
          decoration: BoxDecoration(
            color: status == TimelineStatus.done
                ? AppColors.premiumMint.withValues(alpha: 0.5)
                : colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}
