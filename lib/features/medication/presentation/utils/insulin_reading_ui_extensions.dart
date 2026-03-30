import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/insulin_reading.dart';

extension InsulinReadingUIX on BloodSugarLevel {
  String label(BuildContext context) {
    switch (this) {
      case BloodSugarLevel.low:
        return context.l10n.statusLowLevel;
      case BloodSugarLevel.normal:
        return context.l10n.statusNormalLevel;
      case BloodSugarLevel.high:
        return context.l10n.statusHighLevel;
      case BloodSugarLevel.veryHigh:
        return context.l10n.statusVeryHigh;
      case BloodSugarLevel.dangerous:
        return context.l10n.statusDangerous;
      case BloodSugarLevel.prediabetes:
        return context.l10n.statusPrediabetes;
      case BloodSugarLevel.diabetes:
        return context.l10n.statusDiabetes;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case BloodSugarLevel.low:
        return Colors.red;
      case BloodSugarLevel.normal:
        return Colors.green;
      case BloodSugarLevel.high:
        return Colors.orange;
      case BloodSugarLevel.veryHigh:
        return Colors.deepOrange;
      case BloodSugarLevel.dangerous:
        return Colors.red;
      case BloodSugarLevel.prediabetes:
        return Colors.orange;
      case BloodSugarLevel.diabetes:
        return Colors.red;
    }
  }
}

extension ReadingTypeUIX on ReadingType {
  String label(BuildContext context) {
    switch (this) {
      case ReadingType.fasting:
        return context.l10n.fasting;
      case ReadingType.postprandial:
        return context.l10n.postprandial;
      case ReadingType.beforeSleep:
        return context.l10n.beforeSleep;
      case ReadingType.hba1c:
        return context.l10n.hba1c;
    }
  }
}
