import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/routes/route_constants.dart';
import '../../../medication/domain/entities/dose_timeline_entry.dart';
import '../../../medication/domain/entities/intake_status.dart';
import '../../../medication/presentation/cubit/intake_cubit.dart';
import '../../../medication/presentation/utils/medication_ui_labels.dart';
import '../utils/dose_timeline_ui.dart';
import 'dashboard_intake_section.dart';

/// The next dose due today, with Taken / Snooze actions that update the
/// intake task (and its reminders) through [IntakeCubit].
class DashboardNextDoseCard extends StatelessWidget {
  static const Duration snoozeDuration = Duration(minutes: 15);

  const DashboardNextDoseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الجرعة القادمة',
              style: AppTextStyles.h2.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () => context.push(RouteConstants.medicationHistory),
              child: Text(
                'التفاصيل',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DashboardIntakeSection(
            builder: (context, summary) {
              final next = summary.nextDose;
              return next == null
                  ? const _NoUpcomingDose()
                  : _NextDoseDetails(dose: next);
            },
          ),
        ),
      ],
    );
  }
}

class _NoUpcomingDose extends StatelessWidget {
  const _NoUpcomingDose();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          PhosphorIconsFill.checkCircle,
          color: AppColors.secondary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'لا توجد جرعات قادمة اليوم',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _NextDoseDetails extends StatelessWidget {
  final DoseTimelineEntry dose;

  const _NextDoseDetails({required this.dose});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final task = dose.task;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.statusUpcomingBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  PhosphorIconsFill.pill,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          task.medicationName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.h3.copyWith(
                            color: isDark ? AppColors.darkText : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.statusUpcomingBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          formatDueIn(dose, DateTime.now()),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.statusUpcomingText,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        PhosphorIconsRegular.clock,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${formatDoseTime(dose.dueAt)} - ${task.slot.arabicLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.read<IntakeCubit>().changeTaskStatus(
                      taskId: task.id,
                      status: IntakeStatus.taken,
                      takenAt: DateTime.now(),
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 46),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(PhosphorIconsBold.checkCircle, size: 18),
                label: Text(
                  'تم التناول',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.read<IntakeCubit>().changeTaskStatus(
                      taskId: task.id,
                      status: IntakeStatus.snoozed,
                      snoozeUntil: DateTime.now().add(
                        DashboardNextDoseCard.snoozeDuration,
                      ),
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'تأجيل 15د',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
