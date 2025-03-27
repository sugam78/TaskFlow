part of 'chat_task_bloc.dart';

@immutable
sealed class ChatTaskEvent {}

final class CreateTask extends ChatTaskEvent{
 final String title, description, assignedToEmail, groupId;

  CreateTask(this.title, this.description, this.assignedToEmail, this.groupId);
}

final class UpdateTask extends ChatTaskEvent{
 final String taskId,status;

  UpdateTask(this.taskId, this.status);
}
