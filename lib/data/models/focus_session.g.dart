// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FocusSessionAdapter extends TypeAdapter<FocusSession> {
  @override
  final int typeId = 4;

  @override
  FocusSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusSession(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      plannedMinutes: fields[3] as int,
      actualMinutes: fields[4] as int,
      taskId: fields[5] as String?,
      subjectId: fields[6] as String?,
      completed: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FocusSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.plannedMinutes)
      ..writeByte(4)
      ..write(obj.actualMinutes)
      ..writeByte(5)
      ..write(obj.taskId)
      ..writeByte(6)
      ..write(obj.subjectId)
      ..writeByte(7)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
