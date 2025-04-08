import 'package:hive/hive.dart';
import 'package:taskflow/shared/data/models/task_model.dart';

part 'messages_model.g.dart';


@HiveType(typeId: 4)
class MessagesList {
  @HiveField(0)
  final List<MessageModel> messages;

  const MessagesList({required this.messages});

  factory MessagesList.fromJson(List<dynamic> jsonList) {
    return MessagesList(
      messages: jsonList.map((json) => MessageModel.fromJson(json)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return messages.map((message) => message.toJson()).toList();
  }
}

@HiveType(typeId: 5)
class MessageModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sender;

  @HiveField(2)
  final String senderName;

  @HiveField(3)
  final String group;

  @HiveField(4)
  final String? content;

  @HiveField(5)
  final TaskModel? task;

  @HiveField(6)
  final String? fileUrl;

  @HiveField(7)
  final String type;

  @HiveField(8)
  final DateTime timestamp;

  @HiveField(9)
  final bool isCurrentUser;

  const MessageModel({
    required this.id,
    required this.sender,
    required this.senderName,
    required this.group,
    this.content,
    this.task,
    this.fileUrl,
    required this.type,
    required this.timestamp,
    required this.isCurrentUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: json['sender'],
      senderName: json['senderName'],
      group: json['group'],
      content: json['content'],
      task: json['task'] != null ? TaskModel.fromJson(json['task']) : null,
      fileUrl: json['file'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      isCurrentUser: json['isCurrentUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "sender": sender,
      "senderName": senderName,
      "group": group,
      "content": content,
      "task": task?.toJson(),
      "file": fileUrl,
      "type": type,
      "timestamp": timestamp.toIso8601String(),
      'isCurrentUser': isCurrentUser,
    };
  }
}


