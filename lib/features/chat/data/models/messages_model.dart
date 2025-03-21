

import 'package:taskflow/shared/data/models/task_model.dart';

class MessagesList {
  final List<MessageModel> messages;

  MessagesList({required this.messages});

  factory MessagesList.fromJson(List<dynamic> jsonList) {
    return MessagesList(
      messages: jsonList.map((json) => MessageModel.fromJson(json)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return messages.map((message) => message.toJson()).toList();
  }
}


class MessageModel {
  final String id;
  final String sender;
  final String senderName;
  final String group;
  final String? content;
  final TaskModel? task;
  final String? fileUrl;
  final String type;
  final DateTime timestamp;
  final bool isCurrentUser;

  MessageModel({
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

  // Convert JSON to Message Object
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      sender: json['sender'],
      senderName: json['senderName'],
      group: json['group'],
      content: json['content'],
      task: json['task'] != null ? TaskModel.fromJson(json['task']) : null, // Convert JSON to Task object
      fileUrl: json['file'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      isCurrentUser: json['isCurrentUser']
    );
  }

  // Convert Message Object to JSON
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
