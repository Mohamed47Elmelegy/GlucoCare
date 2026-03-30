import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/premium_card.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/entities/intake_task.dart';

class IntakeTaskCardWidget extends StatelessWidget {
  final IntakeTask task;
  final Function(IntakeStatus status, {DateTime? takenAt, DateTime? snoozeUntil}) onStatusChanged;

  const IntakeTaskCardWidget({
    super.key,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task.status.isTaken;
    final bool isSkipped = task.status.isSkipped;
    final bool isSnoozed = task.status.isSnoozed;

    return PremiumCard(
      margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildIcon(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.medicationName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted || isSkipped ? context.colorScheme.onSurface.withOpacity(0.5) : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.scheduledTime.format(context)}${isSnoozed ? " • ${_formatSnooze(task.snoozeUntil!)}" : ""}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          if (task.status.isPending || isSnoozed) _buildActions(context)
          else if (isCompleted) Icon(Icons.check_circle, color: context.colorScheme.primary)
          else if (isSkipped) Icon(Icons.block, color: context.colorScheme.error.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.medication_rounded,
        color: context.colorScheme.primary,
        size: 24,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionBtn(
          icon: Icons.timer_outlined,
          color: Colors.orange,
          onPressed: () => onStatusChanged(
            IntakeStatus.snoozed,
            snoozeUntil: DateTime.now().add(const Duration(minutes: 15)),
          ),
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          icon: Icons.close_rounded,
          color: Colors.redAccent,
          onPressed: () => onStatusChanged(IntakeStatus.skipped),
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          icon: Icons.check_rounded,
          color: context.colorScheme.primary,
          onPressed: () => onStatusChanged(IntakeStatus.taken, takenAt: DateTime.now()),
        ),
      ],
    );
  }

  String _formatSnooze(DateTime time) {
    return 'Snoozed until ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
