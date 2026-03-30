import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_ai/core/storage/hive_utils.dart';

void main() {
  group('HiveUtils safeCast', () {
    test('should return value when it is already of correct type', () {
      expect(HiveUtils.safeCast<int>(5, 0), 5);
      expect(HiveUtils.safeCast<String>('hello', ''), 'hello');
      expect(HiveUtils.safeCast<bool>(true, false), true);
    });

    test('should return default value when value is null', () {
      expect(HiveUtils.safeCast<int>(null, 0), 0);
      expect(HiveUtils.safeCast<String>(null, 'default'), 'default');
    });

    test('should cast String to int', () {
      expect(HiveUtils.safeCast<int>('123', 0), 123);
      expect(HiveUtils.safeCast<int>('invalid', 0), 0); // fallback
    });

    test('should cast double to int', () {
      expect(HiveUtils.safeCast<int>(12.5, 0), 12);
    });

    test('should cast String to double', () {
      expect(HiveUtils.safeCast<double>('12.5', 0.0), 12.5);
      expect(HiveUtils.safeCast<double>('invalid', 0.0), 0.0); // fallback
    });

    test('should cast int to double', () {
      expect(HiveUtils.safeCast<double>(10, 0.0), 10.0);
    });

    test('should cast int to bool', () {
      expect(HiveUtils.safeCast<bool>(1, false), true);
      expect(HiveUtils.safeCast<bool>(0, true), false);
    });

    test('should cast String to bool', () {
      expect(HiveUtils.safeCast<bool>('true', false), true);
      expect(HiveUtils.safeCast<bool>('1', false), true);
      expect(HiveUtils.safeCast<bool>('false', true), false);
      expect(
        HiveUtils.safeCast<bool>('invalid', true),
        false,
      ); // fallback because != 'true' or '1', wait, the logic currently only checks true conditions
    });

    test('should parse DateTime from int (milliseconds)', () {
      final now = DateTime.now();
      final ms = now.millisecondsSinceEpoch;
      final result = HiveUtils.safeCast<DateTime>(ms, DateTime(2000));
      expect(result.millisecondsSinceEpoch, ms);
    });

    test('should parse DateTime from String', () {
      final dateString = '2026-03-14T10:00:00.000';
      final expectedDate = DateTime.parse(dateString);
      final result = HiveUtils.safeCast<DateTime>(dateString, DateTime(2000));
      expect(result, expectedDate);
    });

    test('should fallback DateTime parsing when format is invalid', () {
      final defaultDate = DateTime(2000);
      final result = HiveUtils.safeCast<DateTime>('invalid-date', defaultDate);
      expect(result, defaultDate);
    });

    test('should fallback DateTime when given unparseable type like bool', () {
      final defaultDate = DateTime(2000);
      // Simulating the error user faced where bool was read as DateTime
      final result = HiveUtils.safeCast<DateTime>(true, defaultDate);
      expect(result, defaultDate);
    });
  });
}
