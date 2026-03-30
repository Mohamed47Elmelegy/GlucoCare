import 'package:hive/hive.dart';
import '../../domain/entities/lab_test.dart';

part 'lab_test_model.g.dart';

@HiveType(typeId: 4)
class LabTestModel extends LabTest {
  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get testName => super.testName;

  @override
  @HiveField(2)
  String get result => super.result;

  @override
  @HiveField(3)
  String get unit => super.unit;

  @override
  @HiveField(4)
  String get referenceRange => super.referenceRange;

  @override
  @HiveField(5)
  DateTime get date => super.date;

  @override
  @HiveField(6)
  String? get notes => super.notes;

  @override
  @HiveField(7)
  String get category => super.category;

  const LabTestModel({
    required super.id,
    required super.testName,
    required super.result,
    required super.unit,
    required super.referenceRange,
    required super.date,
    super.notes,
    required super.category,
  });

  factory LabTestModel.fromEntity(LabTest entity) {
    return LabTestModel(
      id: entity.id,
      testName: entity.testName,
      result: entity.result,
      unit: entity.unit,
      referenceRange: entity.referenceRange,
      date: entity.date,
      notes: entity.notes,
      category: entity.category,
    );
  }
}
