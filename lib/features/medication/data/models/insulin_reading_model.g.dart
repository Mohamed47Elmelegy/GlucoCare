// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insulin_reading_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsulinReadingModelAdapter extends TypeAdapter<InsulinReadingModel> {
  @override
  final int typeId = 3;

  @override
  InsulinReadingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsulinReadingModel(
      id: fields[0] as String,
      value: fields[1] as double,
      timestamp: fields[2] as DateTime,
      readingType: fields[4] == null ? 'fasting' : fields[4] as String?,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InsulinReadingModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.readingType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsulinReadingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
