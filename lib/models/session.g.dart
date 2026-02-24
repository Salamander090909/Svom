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
      stroke: fields[1] as String,
      intensity: fields[2] as String,
      date: fields[3] as DateTime,
      timeInSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.distance)
      ..writeByte(1)
      ..write(obj.stroke)
      ..writeByte(2)
      ..write(obj.intensity)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.timeInSeconds);
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
