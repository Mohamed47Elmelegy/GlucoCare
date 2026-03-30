// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_schedule_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationScheduleModelAdapter
    extends TypeAdapter<MedicationScheduleModel> {
  @override
  final int typeId = 22;

  @override
  MedicationScheduleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationScheduleModel(
      id: fields[0] as String,
      medicationId: fields[1] as String,
      times: (fields[2] as List).cast<TimeValueModel>(),
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime?,
      reminderEnabled: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationScheduleModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicationId)
      ..writeByte(2)
      ..write(obj.times)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.reminderEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationScheduleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimeValueModelAdapter extends TypeAdapter<TimeValueModel> {
  @override
  final int typeId = 24;

  @override
  TimeValueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeValueModel(
      hour: fields[0] as int,
      minute: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeValueModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.minute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeValueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
