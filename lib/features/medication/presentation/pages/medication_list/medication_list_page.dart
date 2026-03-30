import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/routes/route_constants.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_app_bar.dart';
import 'medication_list_listener.dart';

class MedicationListPage extends StatelessWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PremiumAppBar(
        title: context.l10n.myMedications,
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.bold)),
            onPressed: () => context.push(RouteConstants.addMedication),
          ),
        ],
      ),
      body: const MedicationListListener(),
    );
  }
}
