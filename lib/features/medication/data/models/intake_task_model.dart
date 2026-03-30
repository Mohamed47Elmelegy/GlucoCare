import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/intake_status.dart';
import '../../domain/entities/intake_task.dart';
import '../../domain/entities/meal_slot.dart';

part 'intake_task_model.g.dart';

@HiveType(typeId: 25)
class IntakeTaskModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String medicationId;
  @HiveField(2)
  final String medicationName;
  @HiveField(3)
  final String slot;
  @HiveField(4)
  final String scheduledTime; // "HH:mm"
  @HiveField(5)
  final DateTime date;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final DateTime? takenAt;
  @HiveField(8)
  final DateTime? snoozeUntil;

  IntakeTaskModel({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.slot,
    required this.scheduledTime,
    required this.date,
    required this.status,
    this.takenAt,
    this.snoozeUntil,
  });

  factory IntakeTaskModel.fromEntity(IntakeTask task) {
    return IntakeTaskModel(
      id: task.id,
      medicationId: task.medicationId,
      medicationName: task.medicationName,
      slot: task.slot.name,
      scheduledTime: '${task.scheduledTime.hour}:${task.scheduledTime.minute}',
      date: task.date,
      status: task.status.name,
      takenAt: task.takenAt,
      snoozeUntil: task.snoozeUntil,
    );
  }

  IntakeTask toEntity() {
    final timeParts = scheduledTime.split(':');
    return IntakeTask(
      id: id,
      medicationId: medicationId,
      medicationName: medicationName,
      slot: MealSlot.values.byName(slot),
      scheduledTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      date: date,
      status: IntakeStatus.values.byName(status),
      takenAt: takenAt,
      snoozeUntil: snoozeUntil,
    );
  }

  factory IntakeTaskModel.fromJson(Map<String, dynamic> json) {
    return IntakeTaskModel(
      id: json['id'] as String? ?? '',
      medicationId: json['medicationId'] as String? ?? '',
      medicationName: json['medicationName'] as String? ?? '',
      slot: json['slot'] as String? ?? MealSlot.breakfast.name,
      scheduledTime: json['scheduledTime'] as String? ?? '08:00',
      date: _parseDateTime(json['date']),
      status: json['status'] as String? ?? IntakeStatus.skipped.name,
      takenAt: json['takenAt'] != null ? _parseDateTime(json['takenAt']) : null,
      snoozeUntil: json['snoozeUntil'] != null ? _parseDateTime(json['snoozeUntil']) : null,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    if (value is DateTime) return value;
    try {
      if (value.runtimeType.toString().contains('Timestamp')) {
        return (value as dynamic).toDate() as DateTime;
      }
    } catch (_) {}
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'slot': slot,
      'scheduledTime': scheduledTime,
      'date': date.toIso8601String(),
      'status': status,
      'takenAt': takenAt?.toIso8601String(),
      'snoozeUntil': snoozeUntil?.toIso8601String(),
    };
  }
}
