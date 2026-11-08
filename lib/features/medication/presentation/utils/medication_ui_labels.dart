import '../../domain/entities/meal_slot.dart';
import '../../domain/entities/medication_type.dart';

// Arabic display labels, matching the Arabic-only medication and dashboard
// screens until they move to the ARB files.

extension MealSlotUi on MealSlot {
  String get arabicLabel => switch (this) {
        MealSlot.breakfast => 'الإفطار',
        MealSlot.lunch => 'الغداء',
        MealSlot.dinner => 'العشاء',
      };
}

extension MedicationTypeUi on MedicationType {
  String get arabicLabel => switch (this) {
        MedicationType.pill => 'أقراص',
        MedicationType.injection => 'حقنة',
        MedicationType.liquid => 'شراب',
        MedicationType.inhaler => 'بخاخ',
        MedicationType.other => 'أخرى',
      };
}
