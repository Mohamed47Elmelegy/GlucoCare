import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'medication_type.dart';
import 'meal_slot.dart';
import 'schedule_type.dart';

class Medication extends Equatable {
  final String id;
  final String name;
  final MedicationType type;
  final List<MealSlot> mealSlots;
  final Map<MealSlot, TimeOfDay> customTimes;
  final ScheduleType scheduleType;
  final int? durationDays;
  final DateTime startDate;
  final bool isActive;
  final String dosage;
  final String unit;
  final String notes;

  const Medication({
    required this.id,
    required this.name,
    required this.type,
    required this.mealSlots,
    required this.customTimes,
    required this.scheduleType,
    required this.startDate,
    required this.isActive,
    required this.dosage,
    required this.unit,
    required this.notes,
    this.durationDays,
  });

  DateTime? get endDate {
    if (scheduleType == ScheduleType.daily || durationDays == null) {
      return null;
    }
    return startDate.add(Duration(days: durationDays!));
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        mealSlots,
        customTimes,
        scheduleType,
        durationDays,
        startDate,
        isActive,
        dosage,
        unit,
        notes,
      ];

  Medication copyWith({
    String? id,
    String? name,
    MedicationType? type,
    List<MealSlot>? mealSlots,
    Map<MealSlot, TimeOfDay>? customTimes,
    ScheduleType? scheduleType,
    int? durationDays,
    DateTime? startDate,
    bool? isActive,
    String? dosage,
    String? unit,
    String? notes,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      mealSlots: mealSlots ?? this.mealSlots,
      customTimes: customTimes ?? this.customTimes,
      scheduleType: scheduleType ?? this.scheduleType,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
    );
  }
}
