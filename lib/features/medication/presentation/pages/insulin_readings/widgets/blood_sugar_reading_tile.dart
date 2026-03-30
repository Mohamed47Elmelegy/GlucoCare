import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../domain/entities/insulin_reading.dart';
import '../../../utils/insulin_reading_ui_extensions.dart';

class BloodSugarReadingTile extends StatelessWidget {
  final InsulinReading reading;

  const BloodSugarReadingTile({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    final level = reading.level;
    final statusLabel = level.label(context);
    final statusColor = level.color(context);
    final isHbA1c = reading.readingType == ReadingType.hba1c;
    final unit = isHbA1c ? '%' : 'mg/dL';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.bloodtype, color: statusColor),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${reading.value} $unit — $statusLabel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: statusColor,
                ),
              ),
            ),
            if (reading.isDangerous)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.warning, color: Colors.red),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              reading.readingType.label(context),
              style: TextStyle(
                color: context.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              DateFormat('MMM d, h:mm a').format(reading.timestamp),
              style: TextStyle(color: context.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        trailing:
            reading.note != null && reading.note!.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(reading.note!),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
