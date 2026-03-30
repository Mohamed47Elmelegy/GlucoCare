import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/entities/intake_task.dart';
import 'intake_task_card_widget.dart';

class MealSlotSectionWidget extends StatelessWidget {
  final String title;
  final List<IntakeTask> tasks;
  final Function(String taskId, IntakeStatus status, {DateTime? takenAt, DateTime? snoozeUntil}) onStatusChanged;

  const MealSlotSectionWidget({
    super.key,
    required this.title,
    required this.tasks,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...tasks.map(
          (task) => IntakeTaskCardWidget(
            task: task,
            onStatusChanged: (status, {takenAt, snoozeUntil}) => onStatusChanged(
              task.id,
              status,
              takenAt: takenAt,
              snoozeUntil: snoozeUntil,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
