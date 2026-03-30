import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../domain/entities/insulin_reading.dart';
import 'widgets/blood_sugar_reading_tile.dart';

class InsulinReadingsView extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<InsulinReading> readings;
  final VoidCallback onRetry;

  const InsulinReadingsView({
    super.key,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.readings,
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
              Text(errorMessage ?? context.l10n.errorLoadingReadings),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (readings.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bloodtype_outlined,
                size: 80,
                color: context.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.noReadingsRecordedYet,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.tapToAddFirstReading,
                style: TextStyle(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        return BloodSugarReadingTile(reading: readings[index]);
      },
    );
  }
}
