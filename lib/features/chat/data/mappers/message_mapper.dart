import 'package:taskflow/features/chat/data/models/messages_model.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/shared/domain/entities/task.dart';

Messages mapMessagesToEntity(MessagesList messagesList) {
  return Messages(
    messages: messagesList.messages.map((message) {
      return Message(
        id: message.id,
        sender: message.sender,
        senderName: message.senderName,
        group: message.group,
        content: message.content,
        task: message.task != null
            ? Task(
          id: message.task!.id,
          title: message.task!.title,
          description: message.task!.description,
          assignedTo: message.task!.assignedTo,
          status: message.task!.status,
          dueDate: message.task!.dueDate,
          createdBy: message.task!.createdBy,
          createdAt: message.task!.createdAt,
          updatedAt: message.task!.updatedAt,
        )
            : null,
        fileUrl: message.fileUrl,
        type: message.type,
        timestamp: message.timestamp,
        isCurrentUser: message.isCurrentUser
      );
    }).toList(),
  );
}

Message mapMessageToEntity(MessageModel message) {
  return Message(
      id: message.id,
      sender: message.sender,
      senderName: message.senderName,
      group: message.group,
      content: message.content,
      task: message.task != null
          ? Task(
        id: message.task!.id,
        title: message.task!.title,
        description: message.task!.description,
        assignedTo: message.task!.assignedTo,
        status: message.task!.status,
        dueDate: message.task!.dueDate,
        createdBy: message.task!.createdBy,
        createdAt: message.task!.createdAt,
        updatedAt: message.task!.updatedAt,
      )
          : null,
      fileUrl: message.fileUrl,
      type: message.type,
      timestamp: message.timestamp,
      isCurrentUser: message.isCurrentUser
  );
}
