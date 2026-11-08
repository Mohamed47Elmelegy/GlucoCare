import 'time_value.dart';

enum MealSlot {
  breakfast,
  lunch,
  dinner;

  /// One dose per slot, so a medication can be scheduled at most this many
  /// times a day.
  static const int maxDailyDoses = 3;

  /// The slots used for [count] doses a day: 1 → breakfast; 2 → breakfast and
  /// dinner; 3 → all three. Throws [RangeError] outside 1..[maxDailyDoses].
  static List<MealSlot> forDailyDoses(int count) {
    RangeError.checkValueInInterval(count, 1, maxDailyDoses, 'count');
    return switch (count) {
      1 => const [MealSlot.breakfast],
      2 => const [MealSlot.breakfast, MealSlot.dinner],
      _ => MealSlot.values,
    };
  }

  /// Suggested dose time when the user hasn't picked one.
  TimeValue get defaultTime => switch (this) {
        MealSlot.breakfast => const TimeValue(hour: 8, minute: 0),
        MealSlot.lunch => const TimeValue(hour: 14, minute: 0),
        MealSlot.dinner => const TimeValue(hour: 20, minute: 0),
      };

  String get label {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.dinner:
        return 'Dinner';
    }
  }
}
