part of 'chat_messages_bloc.dart';

@immutable
sealed class ChatMessagesState {}

final class ChatMessagesInitial extends ChatMessagesState {}
final class ChatMessagesSent extends ChatMessagesState {}
final class ChatMessagesSending extends ChatMessagesState {}
final class ChatMessagesFetching extends ChatMessagesState {}
final class ChatMessagesFetched extends ChatMessagesState {
  final Messages messages;

  ChatMessagesFetched(this.messages);
}
final class ChatMessagesError extends ChatMessagesState {
  final String message;

  ChatMessagesError(this.message);
}
