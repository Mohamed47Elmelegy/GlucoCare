// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_test_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabTestModelAdapter extends TypeAdapter<LabTestModel> {
  @override
  final int typeId = 4;

  @override
  LabTestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabTestModel(
      id: fields[0] as String,
      testName: fields[1] as String,
      result: fields[2] as String,
      unit: fields[3] as String,
      referenceRange: fields[4] as String,
      date: fields[5] as DateTime,
      notes: fields[6] as String?,
      category: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LabTestModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.testName)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.referenceRange)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabTestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
