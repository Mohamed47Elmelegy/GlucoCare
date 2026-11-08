import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/meal_slot.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/time_value.dart';

void main() {
  group('MealSlot.forDailyDoses', () {
    test('one dose a day is at breakfast', () {
      expect(MealSlot.forDailyDoses(1), [MealSlot.breakfast]);
    });

    test('two doses a day are at breakfast and dinner', () {
      expect(MealSlot.forDailyDoses(2), [MealSlot.breakfast, MealSlot.dinner]);
    });

    test('three doses a day use every slot', () {
      expect(MealSlot.forDailyDoses(3), MealSlot.values);
    });

    test('rejects counts outside 1..maxDailyDoses', () {
      expect(() => MealSlot.forDailyDoses(0), throwsRangeError);
      expect(() => MealSlot.forDailyDoses(MealSlot.maxDailyDoses + 1), throwsRangeError);
    });
  });

  test('default times match the intake generator fallbacks (08:00/14:00/20:00)', () {
    expect(MealSlot.breakfast.defaultTime, const TimeValue(hour: 8, minute: 0));
    expect(MealSlot.lunch.defaultTime, const TimeValue(hour: 14, minute: 0));
    expect(MealSlot.dinner.defaultTime, const TimeValue(hour: 20, minute: 0));
  });
}
