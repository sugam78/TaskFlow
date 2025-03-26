part of 'send_message_bloc.dart';

@immutable
sealed class SendMessageState {}

final class SendMessageInitial extends SendMessageState {}

final class MessagesSent extends SendMessageState {}
final class MessagesSending extends SendMessageState {}

final class MessagesError extends SendMessageState {
  final String message;

  MessagesError(this.message);
}
