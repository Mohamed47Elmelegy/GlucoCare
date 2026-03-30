import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/features/medication/domain/entities/insulin_reading.dart';

void main() {
  group('InsulinReadingX Classification', () {
    group('Standard Readings (mg/dL)', () {
      test('Low: < 70', () {
        final reading69 = InsulinReading(
          id: '1',
          value: 69,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        expect(reading69.level, BloodSugarLevel.low);
      });

      test('Normal: 70 - 140', () {
        final reading70 = InsulinReading(
          id: '1',
          value: 70,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        final reading140 = InsulinReading(
          id: '2',
          value: 140,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        expect(reading70.level, BloodSugarLevel.normal);
        expect(reading140.level, BloodSugarLevel.normal);
      });

      test('High: 140 - 180', () {
        final reading141 = InsulinReading(
          id: '1',
          value: 141,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        final reading180 = InsulinReading(
          id: '2',
          value: 180,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        expect(reading141.level, BloodSugarLevel.high);
        expect(reading180.level, BloodSugarLevel.high);
      });

      test('Very High: 180 - 300', () {
        final reading181 = InsulinReading(
          id: '1',
          value: 181,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        final reading300 = InsulinReading(
          id: '2',
          value: 300,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        expect(reading181.level, BloodSugarLevel.veryHigh);
        expect(reading300.level, BloodSugarLevel.veryHigh);
      });

      test('Dangerous: > 300', () {
        final reading301 = InsulinReading(
          id: '1',
          value: 301,
          readingType: ReadingType.fasting,
          timestamp: DateTime.now(),
        );
        expect(reading301.level, BloodSugarLevel.dangerous);
        expect(reading301.isDangerous, isTrue);
      });
    });

    group('HbA1c Readings (%)', () {
      test('Normal: < 5.7', () {
        final reading56 = InsulinReading(
          id: '1',
          value: 5.6,
          readingType: ReadingType.hba1c,
          timestamp: DateTime.now(),
        );
        expect(reading56.level, BloodSugarLevel.normal);
      });

      test('Prediabetes: 5.7 - 6.4', () {
        final reading57 = InsulinReading(
          id: '1',
          value: 5.7,
          readingType: ReadingType.hba1c,
          timestamp: DateTime.now(),
        );
        final reading64 = InsulinReading(
          id: '2',
          value: 6.4,
          readingType: ReadingType.hba1c,
          timestamp: DateTime.now(),
        );
        expect(reading57.level, BloodSugarLevel.prediabetes);
        expect(reading64.level, BloodSugarLevel.prediabetes);
      });

      test('Diabetes: >= 6.5', () {
        final reading65 = InsulinReading(
          id: '1',
          value: 6.5,
          readingType: ReadingType.hba1c,
          timestamp: DateTime.now(),
        );
        expect(reading65.level, BloodSugarLevel.diabetes);
      });
    });
  });
}
