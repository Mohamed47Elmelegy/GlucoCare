import 'package:equatable/equatable.dart';

class LabTest extends Equatable {
  final String id;
  final String testName;
  final String result;
  final String unit;
  final String referenceRange;
  final DateTime date;
  final String? notes;
  final String category; // e.g., Blood, Urine, etc.

  const LabTest({
    required this.id,
    required this.testName,
    required this.result,
    required this.unit,
    required this.referenceRange,
    required this.date,
    this.notes,
    required this.category,
  });

  @override
  List<Object?> get props => [
    id,
    testName,
    result,
    unit,
    referenceRange,
    date,
    notes,
    category,
  ];
}
