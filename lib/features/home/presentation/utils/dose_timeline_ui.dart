import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../medication/domain/entities/dose_timeline_entry.dart';

// Dashboard copy is Arabic-only, like the rest of this screen, until the
// screen moves to the ARB files.

/// Label, icon and colours for one dose status on the dashboard.
class DoseStatusStyle {
  final String label;
  final IconData icon;
  final Color accent;
  final Color chipBackground;
  final Color chipText;

  const DoseStatusStyle({
    required this.label,
    required this.icon,
    required this.accent,
    required this.chipBackground,
    required this.chipText,
  });
}

extension DoseTimelineStatusUi on DoseTimelineStatus {
  DoseStatusStyle get style => switch (this) {
        DoseTimelineStatus.taken => const DoseStatusStyle(
            label: 'تم التناول',
            icon: PhosphorIconsBold.check,
            accent: AppColors.statusTakenText,
            chipBackground: AppColors.statusTakenBg,
            chipText: AppColors.statusTakenText,
          ),
        DoseTimelineStatus.missed => const DoseStatusStyle(
            label: 'لم يتم',
            icon: PhosphorIconsBold.x,
            accent: AppColors.danger,
            chipBackground: AppColors.statusMissedBg,
            chipText: AppColors.statusMissedText,
          ),
        DoseTimelineStatus.upcoming => const DoseStatusStyle(
            label: 'قادمة',
            icon: PhosphorIconsFill.bell,
            accent: AppColors.primary,
            chipBackground: AppColors.statusUpcomingBg,
            chipText: AppColors.statusUpcomingText,
          ),
        DoseTimelineStatus.snoozed => const DoseStatusStyle(
            label: 'مؤجلة',
            icon: PhosphorIconsFill.clock,
            accent: AppColors.warning,
            chipBackground: AppColors.statusUpcomingBg,
            chipText: AppColors.statusUpcomingText,
          ),
        DoseTimelineStatus.skipped => const DoseStatusStyle(
            label: 'تم التخطي',
            icon: PhosphorIconsBold.minus,
            accent: AppColors.textSecondary,
            chipBackground: AppColors.surfaceVariant,
            chipText: AppColors.textSecondary,
          ),
      };
}

/// Clock time of a dose, e.g. "٨:٠٠ ص".
String formatDoseTime(DateTime time) => DateFormat('h:mm a', 'ar').format(time);

/// Short "due in" label for the next-dose chip.
String formatDueIn(DoseTimelineEntry entry, DateTime now) {
  if (entry.status == DoseTimelineStatus.snoozed) return 'مؤجلة';
  final minutes = entry.dueAt.difference(now).inMinutes;
  if (minutes <= 0) return 'الآن';
  if (minutes < 60) return 'خلال $minutes د';
  return 'خلال ${minutes ~/ 60} س';
}
