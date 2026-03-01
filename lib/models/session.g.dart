// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 0;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      distance: fields[0] as double,
      timeInSeconds: fields[1] as int,
      stroke: fields[2] as String,
      intensity: fields[3] as String,
      date: fields[4] as DateTime,
      preWorkoutMeal: fields[5] as String?,
      postWorkoutMeal: fields[6] as String?,
      energyLevel: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.distance)
      ..writeByte(1)
      ..write(obj.timeInSeconds)
      ..writeByte(2)
      ..write(obj.stroke)
      ..writeByte(3)
      ..write(obj.intensity)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.preWorkoutMeal)
      ..writeByte(6)
      ..write(obj.postWorkoutMeal)
      ..writeByte(7)
      ..write(obj.energyLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
