import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../domain/entities/medication.dart';

class MedicationListPageBody extends StatelessWidget {
  final List<Medication> medications;

  const MedicationListPageBody({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.pill(PhosphorIconsStyle.light),
              size: 64,
              color: context.colorScheme.outline.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(context.l10n.noMedicationsScheduled),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final med = medications[index];
        final isInjection = med.type.name.toLowerCase().contains('injection');

        return PremiumCard(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.premiumMint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isInjection
                    ? PhosphorIcons.syringe(PhosphorIconsStyle.fill)
                    : PhosphorIcons.pill(PhosphorIconsStyle.fill),
                color: AppColors.premiumMint,
              ),
            ),
            title: Text(
              med.name,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${med.dosage} ${med.unit} • ${med.mealSlots.map((s) => s.label).join(", ")}',
              style: context.textTheme.bodySmall,
            ),
            trailing: Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              size: 20,
              color: context.colorScheme.outline,
            ),
            onTap: () {
              // View details
            },
          ),
        );
      },
    );
  }
}
