// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_mastery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectMasteryAdapter extends TypeAdapter<SubjectMastery> {
  @override
  final int typeId = 3;

  @override
  SubjectMastery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectMastery(
      subjectId: fields[0] as String,
      subjectName: fields[1] as String,
      confidenceScore: fields[2] as double,
      tasksCompleted: fields[3] as int,
      tasksFailed: fields[4] as int,
      timesSnoozed: fields[5] as int,
      lastRevised: fields[6] as DateTime?,
      totalStudyMinutes: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectMastery obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.subjectName)
      ..writeByte(2)
      ..write(obj.confidenceScore)
      ..writeByte(3)
      ..write(obj.tasksCompleted)
      ..writeByte(4)
      ..write(obj.tasksFailed)
      ..writeByte(5)
      ..write(obj.timesSnoozed)
      ..writeByte(6)
      ..write(obj.lastRevised)
      ..writeByte(7)
      ..write(obj.totalStudyMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectMasteryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
