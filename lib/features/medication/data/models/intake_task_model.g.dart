// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntakeTaskModelAdapter extends TypeAdapter<IntakeTaskModel> {
  @override
  final int typeId = 25;

  @override
  IntakeTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntakeTaskModel(
      id: fields[0] as String,
      medicationId: fields[1] as String,
      medicationName: fields[2] as String,
      slot: fields[3] as String,
      scheduledTime: fields[4] as String,
      date: fields[5] as DateTime,
      status: fields[6] as String,
      takenAt: fields[7] as DateTime?,
      snoozeUntil: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, IntakeTaskModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicationId)
      ..writeByte(2)
      ..write(obj.medicationName)
      ..writeByte(3)
      ..write(obj.slot)
      ..writeByte(4)
      ..write(obj.scheduledTime)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.takenAt)
      ..writeByte(8)
      ..write(obj.snoozeUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntakeTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
