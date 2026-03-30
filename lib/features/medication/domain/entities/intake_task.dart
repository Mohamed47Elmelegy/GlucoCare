import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'meal_slot.dart';
import 'intake_status.dart';

class IntakeTask extends Equatable {
  final String id;
  final String medicationId;
  final String medicationName;
  final MealSlot slot; // breakfast | lunch | dinner
  final TimeOfDay scheduledTime;
  final DateTime date; // which day this task belongs to
  final IntakeStatus status; // taken | skipped | snoozed
  final DateTime? takenAt; // timestamp when marked taken
  final DateTime? snoozeUntil; // for snoozed tasks

  const IntakeTask({
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

  @override
  List<Object?> get props => [
        id,
        medicationId,
        medicationName,
        slot,
        scheduledTime,
        date,
        status,
        takenAt,
        snoozeUntil,
      ];

  IntakeTask copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    MealSlot? slot,
    TimeOfDay? scheduledTime,
    DateTime? date,
    IntakeStatus? status,
    DateTime? takenAt,
    DateTime? snoozeUntil,
  }) {
    return IntakeTask(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      slot: slot ?? this.slot,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      date: date ?? this.date,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
      snoozeUntil: snoozeUntil ?? this.snoozeUntil,
    );
  }
}
