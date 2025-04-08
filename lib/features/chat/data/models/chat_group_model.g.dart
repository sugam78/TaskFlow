// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_group_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatGroupModelAdapter extends TypeAdapter<ChatGroupModel> {
  @override
  final int typeId = 2;

  @override
  ChatGroupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatGroupModel(
      id: fields[0] as String,
      name: fields[1] as String,
      members: (fields[2] as List).cast<MemberModel>(),
      admins: (fields[3] as List).cast<String>(),
      messages: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatGroupModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.members)
      ..writeByte(3)
      ..write(obj.admins)
      ..writeByte(4)
      ..write(obj.messages)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatGroupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MemberModelAdapter extends TypeAdapter<MemberModel> {
  @override
  final int typeId = 3;

  @override
  MemberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemberModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemberModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
