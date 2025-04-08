// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessagesListAdapter extends TypeAdapter<MessagesList> {
  @override
  final int typeId = 4;

  @override
  MessagesList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessagesList(
      messages: (fields[0] as List).cast<MessageModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MessagesList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessagesListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final int typeId = 5;

  @override
  MessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModel(
      id: fields[0] as String,
      sender: fields[1] as String,
      senderName: fields[2] as String,
      group: fields[3] as String,
      content: fields[4] as String?,
      task: fields[5] as TaskModel?,
      fileUrl: fields[6] as String?,
      type: fields[7] as String,
      timestamp: fields[8] as DateTime,
      isCurrentUser: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sender)
      ..writeByte(2)
      ..write(obj.senderName)
      ..writeByte(3)
      ..write(obj.group)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.task)
      ..writeByte(6)
      ..write(obj.fileUrl)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.timestamp)
      ..writeByte(9)
      ..write(obj.isCurrentUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
