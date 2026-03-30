// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationModelAdapter extends TypeAdapter<MedicationModel> {
  @override
  final int typeId = 21;

  @override
  MedicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      mealSlots: (fields[3] as List).cast<String>(),
      customTimes: (fields[4] as Map).cast<String, String>(),
      scheduleType: fields[5] as String,
      startDate: fields[7] as DateTime,
      isActive: fields[8] as bool,
      dosage: fields[9] as String,
      unit: fields[10] as String,
      notes: fields[11] as String,
      durationDays: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.mealSlots)
      ..writeByte(4)
      ..write(obj.customTimes)
      ..writeByte(5)
      ..write(obj.scheduleType)
      ..writeByte(6)
      ..write(obj.durationDays)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.dosage)
      ..writeByte(10)
      ..write(obj.unit)
      ..writeByte(11)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
