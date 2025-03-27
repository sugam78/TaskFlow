part of 'chat_task_bloc.dart';

@immutable
sealed class ChatTaskState {}

final class ChatTaskInitial extends ChatTaskState {}
final class ChatTaskLoading extends ChatTaskState {}
final class ChatTaskCreated extends ChatTaskState {
  final String taskId;

  ChatTaskCreated(this.taskId);
}
final class ChatTaskUpdated extends ChatTaskState {
  final String status;
  final String taskId;

  ChatTaskUpdated(this.status, this.taskId);
}
final class ChatTaskError extends ChatTaskState {
  final String message;

  ChatTaskError(this.message);
}
