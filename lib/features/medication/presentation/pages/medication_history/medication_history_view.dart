import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/premium_card.dart';
import '../../../domain/entities/dose_status.dart';
import '../../../domain/entities/dose_history.dart';

class MedicationHistoryView extends StatelessWidget {
  final DateTime selectedDate;
  final bool isLoading;
  final List<DoseHistory> history;
  final bool hasError;

  const MedicationHistoryView({
    super.key,
    required this.selectedDate,
    required this.isLoading,
    required this.history,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: context.colorScheme.surfaceContainerHighest,
          width: double.infinity,
          child: Text(
            '${context.l10n.showingHistoryFor}\n${DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)}',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Text(
          context.l10n.failedToLoadHistory,
        ),
      );
    }

    if (history.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noMedicationsRecorded,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        // For a complete app, we'd look up the medication name by ID.
        // For now, we display the raw ID and time taken.
        return PremiumCard(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Image.asset(
              AppAssets.check,
              width: 32,
              height: 32,
            ),
            title: Text(
              '${context.l10n.medicationId} ${item.medicationId.substring(0, 8)}...',
            ),
            subtitle: Text(
              '${context.l10n.takenAt} ${DateFormat('hh:mm a').format(item.dateTime)}',
            ),
            trailing: item.status == DoseStatus.taken
                ? Text(
                    context.l10n.onTime,
                    style: const TextStyle(color: Colors.green),
                  )
                : Text(
                    context.l10n.late,
                    style: const TextStyle(color: Colors.orange),
                  ),
          ),
        );
      },
    );
  }
}
