// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_tasks_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyTasksModelAdapter extends TypeAdapter<MyTasksModel> {
  @override
  final int typeId = 8;

  @override
  MyTasksModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyTasksModel(
      tasks: (fields[0] as List).cast<TaskModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyTasksModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.tasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyTasksModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
