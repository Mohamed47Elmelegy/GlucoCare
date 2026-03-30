import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/routes/route_constants.dart';
import 'premium_action_card.dart';
import '../../../../l10n/app_localizations.dart';

class PremiumActionGrid extends StatelessWidget {
  final int medsRemaining;
  final double insulinToday;

  const PremiumActionGrid({
    super.key,
    required this.medsRemaining,
    required this.insulinToday,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9,
      children: [
        PremiumActionCard(
          title: l10n.insulinIntake,
          subtitle: l10n.last4Hours,
          icon: PhosphorIcons.syringe(),
          isActive: true,
          statusText: insulinToday > 0 ? l10n.statusLogged : l10n.statusPending,
          onAction: () => context.push(RouteConstants.insulinReadings),
        ),
        PremiumActionCard(
          title: l10n.medication,
          subtitle: medsRemaining > 0
              ? l10n.remainingCount(medsRemaining)
              : l10n.allTaken,
          icon: PhosphorIcons.pill(),
          isActive: medsRemaining > 0,
          statusText: medsRemaining > 0 ? l10n.statusRemain : l10n.statusTaken,
          onAction: () => context.push(RouteConstants.addMedication),
        ),
        PremiumActionCard(
          title: l10n.dailyDiet,
          subtitle: l10n.kcal1200,
          icon: PhosphorIcons.bowlFood(),
          isActive: false,
          statusText: l10n.statusPending,
          onAction: () {},
        ),
        PremiumActionCard(
          title: l10n.heartRate,
          subtitle: l10n.bpmAvg,
          icon: PhosphorIcons.heartbeat(),
          isActive: false,
          statusText: l10n.statusOff,
          onAction: () {},
        ),
      ],
    );
  }
}
