// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_chat_groups_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyChatGroupsModelAdapter extends TypeAdapter<MyChatGroupsModel> {
  @override
  final int typeId = 0;

  @override
  MyChatGroupsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyChatGroupsModel(
      groups: (fields[0] as List).cast<ChatGroupItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyChatGroupsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.groups);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyChatGroupsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatGroupItemAdapter extends TypeAdapter<ChatGroupItem> {
  @override
  final int typeId = 1;

  @override
  ChatGroupItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatGroupItem(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatGroupItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatGroupItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
