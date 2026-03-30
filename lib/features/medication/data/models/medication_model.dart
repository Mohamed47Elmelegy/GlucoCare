import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/medication.dart';
import '../../domain/entities/medication_type.dart';
import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/schedule_type.dart';

part 'medication_model.g.dart';

@HiveType(typeId: 21)
class MedicationModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final List<String> mealSlots;
  @HiveField(4)
  final Map<String, String> customTimes;
  @HiveField(5)
  final String scheduleType;
  @HiveField(6)
  final int? durationDays;
  @HiveField(7)
  final DateTime startDate;
  @HiveField(8)
  final bool isActive;
  @HiveField(9)
  final String dosage;
  @HiveField(10)
  final String unit;
  @HiveField(11)
  final String notes;

  MedicationModel({
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

  factory MedicationModel.fromEntity(Medication medication) {
    return MedicationModel(
      id: medication.id,
      name: medication.name,
      type: medication.type.name,
      mealSlots: medication.mealSlots.map((e) => e.name).toList(),
      customTimes: medication.customTimes.map(
        (key, value) => MapEntry(key.name, '${value.hour}:${value.minute}'),
      ),
      scheduleType: medication.scheduleType.name,
      durationDays: medication.durationDays,
      startDate: medication.startDate,
      isActive: medication.isActive,
      dosage: medication.dosage,
      unit: medication.unit,
      notes: medication.notes,
    );
  }

  Medication toEntity() {
    return Medication(
      id: id,
      name: name,
      type: _getMedicationType(type),
      mealSlots: mealSlots.map((e) => MealSlot.values.byName(e)).toList(),
      customTimes: customTimes.map(
        (key, value) {
          final parts = value.split(':');
          return MapEntry(
            MealSlot.values.byName(key),
            TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
          );
        },
      ),
      scheduleType: ScheduleType.values.byName(scheduleType),
      durationDays: durationDays,
      startDate: startDate,
      isActive: isActive,
      dosage: dosage,
      unit: unit,
      notes: notes,
    );
  }

  static MedicationType _getMedicationType(String type) {
    try {
      return MedicationType.values.byName(type);
    } catch (_) {
      // Fallback for old data if it was index-based or different
      return MedicationType.pill;
    }
  }

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Medication',
      type: json['type'] as String? ?? MedicationType.pill.name,
      mealSlots: json['mealSlots'] != null
          ? List<String>.from(json['mealSlots'] as List)
          : [MealSlot.breakfast.name],
      customTimes: json['customTimes'] != null
          ? Map<String, String>.from(json['customTimes'] as Map)
          : {},
      scheduleType: json['scheduleType'] as String? ?? ScheduleType.daily.name,
      durationDays: json['durationDays'] as int?,
      startDate: _parseDateTime(json['startDate']),
      isActive: json['isActive'] as bool? ?? true,
      dosage: json['dosage'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) return DateTime.parse(value);
    if (value is DateTime) return value;
    // Handle Firestore Timestamp
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
      'name': name,
      'type': type,
      'mealSlots': mealSlots,
      'customTimes': customTimes,
      'scheduleType': scheduleType,
      'durationDays': durationDays,
      'startDate': startDate.toIso8601String(),
      'isActive': isActive,
      'dosage': dosage,
      'unit': unit,
      'notes': notes,
    };
  }
}
