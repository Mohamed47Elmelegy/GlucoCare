import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/routes/route_constants.dart';
import 'dashboard_intake_section.dart';
import 'dose_timeline_tile.dart';

/// Today's doses in due-time order, with a link to the full daily checklist.
class DashboardDoseTimeline extends StatelessWidget {
  const DashboardDoseTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final today = DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'جدول اليوم',
              style: AppTextStyles.h2.copyWith(
                color: isDark ? AppColors.darkText : AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            Text(
              today,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DashboardIntakeSection(
          showStatus: false,
          builder: (context, summary) {
            final doses = summary.timeline;
            if (doses.isEmpty) {
              return Text(
                'لا توجد أدوية مجدولة اليوم',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              );
            }
            return Column(
              children: [
                for (var i = 0; i < doses.length; i++)
                  DoseTimelineTile(
                    dose: doses[i],
                    isFirst: i == 0,
                    isLast: i == doses.length - 1,
                  ),
              ],
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => context.push(RouteConstants.intakeTodo),
            icon: const Icon(PhosphorIconsBold.listChecks, size: 18),
            label: const Text('إدارة جرعات اليوم'),
          ),
        ),
      ],
    );
  }
}
