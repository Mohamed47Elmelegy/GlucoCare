import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_card.dart';
import '../../../domain/entities/medication.dart';

class MedicationListView extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final List<Medication> medications;
  final VoidCallback onRetry;

  const MedicationListView({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.medications,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIcons.warningCircle(PhosphorIconsStyle.fill),
                size: 48,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(context.l10n.errorOccurred),
              TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ),
        ),
      );
    }

    if (medications.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          alignment: Alignment.center,
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
              TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ),
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
              '${med.dosage} ${med.unit} • ${med.mealSlots.map((slot) => slot.label).join(", ")}',
              style: context.textTheme.bodySmall,
            ),
            trailing: Icon(
              PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
              size: 20,
              color: context.colorScheme.outline,
            ),
            onTap: () {
              context.push(RouteConstants.editMedication, extra: med);
            },
          ),
        );
      },
    );
  }
}
