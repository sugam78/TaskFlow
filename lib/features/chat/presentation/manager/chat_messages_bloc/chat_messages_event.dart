part of 'chat_messages_bloc.dart';

@immutable
sealed class ChatMessagesEvent {}

final class GetMessages extends ChatMessagesEvent{
  final String groupId;

  GetMessages(this.groupId);
}

final class SendMessages extends ChatMessagesEvent{
  final String groupId,type;
  final String? content ,fileUrl,taskId;

  SendMessages(this.groupId, this.type, this.content, this.fileUrl, this.taskId);
}

final class ResetChatMessages extends ChatMessagesEvent{}
