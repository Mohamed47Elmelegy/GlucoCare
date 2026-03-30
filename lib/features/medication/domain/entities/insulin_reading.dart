import 'package:equatable/equatable.dart';

enum ReadingType { fasting, postprandial, beforeSleep, hba1c }

enum BloodSugarLevel {
  low,
  normal,
  high,
  veryHigh,
  dangerous,
  prediabetes,
  diabetes
}

class InsulinReading extends Equatable {
  final String id;
  final double value;
  final ReadingType readingType;
  final DateTime timestamp;
  final String? note;

  const InsulinReading({
    required this.id,
    required this.value,
    required this.readingType,
    required this.timestamp,
    this.note,
  });

  @override
  List<Object?> get props => [id, value, readingType, timestamp, note];
}

extension InsulinReadingX on InsulinReading {
  BloodSugarLevel get level {
    if (readingType == ReadingType.hba1c) {
      if (value < 5.7) return BloodSugarLevel.normal;
      if (value < 6.5) return BloodSugarLevel.prediabetes;
      return BloodSugarLevel.diabetes;
    } else {
      if (value < 70) return BloodSugarLevel.low;
      if (value <= 140) return BloodSugarLevel.normal;
      if (value <= 180) return BloodSugarLevel.high;
      if (value <= 300) return BloodSugarLevel.veryHigh;
      return BloodSugarLevel.dangerous;
    }
  }

  bool get isDangerous => level == BloodSugarLevel.dangerous;
}
