


import 'package:taskflow/shared/domain/entities/task.dart';

class Messages{
  final List<Message> messages;

  Messages({required this.messages});
}

class Message {
  final String id;
  final String sender;
  final String senderName;
  final String group;
  final String? content;
  final Task? task;
  final String? fileUrl;
  final String type;
  final DateTime timestamp;
  final bool isCurrentUser;

  Message({
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
}
