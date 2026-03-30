// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoseHistoryModelAdapter extends TypeAdapter<DoseHistoryModel> {
  @override
  final int typeId = 23;

  @override
  DoseHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoseHistoryModel(
      id: fields[0] as String,
      medicationId: fields[1] as String,
      dateTime: fields[2] as DateTime,
      statusIndex: fields[3] as int,
      notes: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DoseHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicationId)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.statusIndex)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoseHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
