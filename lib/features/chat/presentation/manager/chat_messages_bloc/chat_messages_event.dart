part of 'chat_messages_bloc.dart';

@immutable
sealed class ChatMessagesEvent {}

final class GetMessages extends ChatMessagesEvent{
  final String groupId;

  GetMessages(this.groupId);
}
class StartListeningToMessages extends ChatMessagesEvent {}

class StopListeningToMessages extends ChatMessagesEvent {}
class NewMessageReceived extends ChatMessagesEvent {
  final Message message;
  NewMessageReceived(this.message);
}


final class ResetChatMessages extends ChatMessagesEvent{}
