part of 'send_message_bloc.dart';

@immutable
sealed class SendMessageEvent {}

final class SendMessages extends SendMessageEvent{
  final String groupId,type;
  final String? content ,fileUrl,taskId;

  SendMessages(this.groupId, this.type, this.content, this.fileUrl, this.taskId);
}
