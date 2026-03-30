import 'package:flutter/widgets.dart';

enum TimelineStatus { done, next, upcoming }

class MedicationTimelineItem {
  final String label;
  final String time;
  final IconData icon;
  final TimelineStatus status;

  MedicationTimelineItem({
    required this.label,
    required this.time,
    required this.icon,
    required this.status,
  });
}
