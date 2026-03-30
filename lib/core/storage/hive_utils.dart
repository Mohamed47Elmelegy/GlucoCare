import 'package:hive_flutter/hive_flutter.dart';

class HiveUtils {
  /// Safely opens a Hive box, deleting it if a schema mismatch or corruption occurs.
  static Future<Box<T>> openBoxSafely<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      // If there's a type mismatch or corruption, wipe the box and start fresh.
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName);
    }
  }

  /// Safely casts a value from Hive. Handles conversions gracefully.
  /// This prevents `_TypeError` crashes caused by schema updates (e.g., bool read as DateTime).
  static T safeCast<T>(dynamic value, T defaultValue) {
    if (value == null) return defaultValue;

    if (value is T) {
      return value;
    }

    try {
      // Special complex conversions
      if (T == DateTime) {
        if (value is int) {
          return DateTime.fromMillisecondsSinceEpoch(value) as T;
        } else if (value is String) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) return parsed as T;
        }
      } else if (T == String) {
        return value.toString() as T;
      } else if (T == int) {
        if (value is String) {
          final parsed = int.tryParse(value);
          if (parsed != null) return parsed as T;
        } else if (value is double) {
          return value.toInt() as T;
        }
      } else if (T == double) {
        if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed != null) return parsed as T;
        } else if (value is int) {
          return value.toDouble() as T;
        }
      } else if (T == bool) {
        if (value is int) return (value == 1) as T;
        if (value is String) {
          return (value.toLowerCase() == 'true' || value == '1') as T;
        }
      }
    } catch (_) {
      // If any specific parsing fails, fall back to default
    }

    // Unsafe or unsupported conversion fallback
    return defaultValue;
  }
}
