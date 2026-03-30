import 'package:hive/hive.dart';
import '../../domain/entities/insulin_reading.dart';

part 'insulin_reading_model.g.dart';

@HiveType(typeId: 3)
class InsulinReadingModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final String? note;

  @HiveField(4, defaultValue: 'fasting')
  final String? readingType;

  InsulinReadingModel({
    required this.id,
    required this.value,
    required this.timestamp,
    this.readingType,
    this.note,
  });

  InsulinReading toEntity() {
    ReadingType type;
    try {
      type = ReadingType.values.firstWhere(
        (e) => e.name == readingType,
        orElse: () => throw Exception('Fallback to legacy mapping'),
      );
    } catch (_) {
      // Fallback for old localized strings if any
      if (readingType == 'صائم' || readingType == 'Fasting') {
        type = ReadingType.fasting;
      } else if (readingType == 'بعد האכל بساعتين' || readingType == 'Postprandial') {
        type = ReadingType.postprandial;
      } else if (readingType == 'قبل النوم' || readingType == 'Before Sleep') {
        type = ReadingType.beforeSleep;
      } else if (readingType == 'تراكمي' || readingType == 'HbA1c' || readingType == 'السكر التراكمي (HbA1c)') {
        type = ReadingType.hba1c;
      } else {
        type = ReadingType.fasting;
      }
    }

    return InsulinReading(
      id: id,
      value: value,
      readingType: type,
      timestamp: timestamp,
      note: note,
    );
  }

  factory InsulinReadingModel.fromEntity(InsulinReading entity) =>
      InsulinReadingModel(
        id: entity.id,
        value: entity.value,
        readingType: entity.readingType.name,
        timestamp: entity.timestamp,
        note: entity.note,
      );
}
