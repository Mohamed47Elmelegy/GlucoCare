import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_test_ai/features/medication/presentation/bloc/medication_state.dart';
import 'package:flutter_test_ai/features/home/domain/entities/medication_timeline_item.dart';
import 'premium_medication_timeline.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/extensions/context_extension.dart';

class PremiumTimelineSection extends StatelessWidget {
  final MedicationState medState;

  const PremiumTimelineSection({super.key, required this.medState});

  List<MedicationTimelineItem> _getTimelineItems(BuildContext context) {
    if (medState is TodayScheduleLoaded) {
      final state = medState as TodayScheduleLoaded;
      final locale = Localizations.localeOf(context).toString();
      final List<MedicationTimelineItem> items = [];

      for (final med in state.activeMedications) {
        final isTaken = state.takenHistory.any((h) => h.medicationId == med.id);
        
        for (final slot in med.mealSlots) {
          final timeStr = med.customTimes[slot] != null
              ? DateFormat.jm(locale).format(
                  DateTime(
                    2024,
                    1,
                    1,
                    med.customTimes[slot]!.hour,
                    med.customTimes[slot]!.minute,
                  ),
                )
              : "--:--";

          items.add(MedicationTimelineItem(
            label: '${med.name} (${slot.label})',
            time: timeStr,
            icon: med.type.name.toLowerCase().contains('injection')
                ? PhosphorIcons.syringe()
                : PhosphorIcons.pill(),
            status: isTaken ? TimelineStatus.done : TimelineStatus.upcoming,
          ));
        }
      }
      return items;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final items = _getTimelineItems(context);
    final l10n = AppLocalizations.of(context)!;

    if (items.isNotEmpty) {
      return PremiumMedicationTimeline(items: items);
    } else if (medState is MedicationLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            l10n.noMedicationsToday,
            style: TextStyle(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }
  }
}
