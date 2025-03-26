part of 'chat_messages_bloc.dart';

@immutable
abstract class ChatMessagesState {}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesFetching extends ChatMessagesState {}

class ChatMessagesFetched extends ChatMessagesState {
  final Messages messages;

  ChatMessagesFetched(this.messages);
}

class ChatMessagesError extends ChatMessagesState {
  final String error;

  ChatMessagesError(this.error);
}

class ChatMessagesListening extends ChatMessagesState {}

class ChatMessagesStopped extends ChatMessagesState {}
