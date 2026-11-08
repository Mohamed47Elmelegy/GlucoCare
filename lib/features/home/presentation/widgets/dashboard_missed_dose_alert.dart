import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../medication/domain/entities/dose_timeline_entry.dart';
import '../../../medication/domain/entities/intake_status.dart';
import '../../../medication/presentation/cubit/intake_cubit.dart';
import '../utils/dose_timeline_ui.dart';
import 'dashboard_intake_section.dart';

/// Warns about today's missed doses; hidden when there are none.
class DashboardMissedDoseAlert extends StatelessWidget {
  const DashboardMissedDoseAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardIntakeSection(
      showStatus: false,
      builder: (context, summary) {
        final missed = summary.missedDoses;
        if (missed.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _MissedDoseCard(
            dose: missed.first,
            otherMissedCount: missed.length - 1,
          ),
        );
      },
    );
  }
}

class _MissedDoseCard extends StatelessWidget {
  final DoseTimelineEntry dose;
  final int otherMissedCount;

  const _MissedDoseCard({required this.dose, required this.otherMissedCount});

  @override
  Widget build(BuildContext context) {
    final others = otherMissedCount > 0
        ? ' جرعات فائتة أخرى: $otherMissedCount.'
        : '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.statusMissedBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            PhosphorIconsFill.warningCircle,
            color: AppColors.statusMissedText,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جرعة فائتة!',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusMissedText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'لقد فاتك موعد "${dose.task.medicationName}" '
                  'الساعة ${formatDoseTime(dose.dueAt)}.$others',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.statusMissedText,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.read<IntakeCubit>().changeTaskStatus(
                  taskId: dose.task.id,
                  status: IntakeStatus.taken,
                  takenAt: DateTime.now(),
                ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'تدارك الآن',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.statusMissedText,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
