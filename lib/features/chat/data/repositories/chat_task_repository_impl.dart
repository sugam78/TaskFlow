import 'package:taskflow/features/chat/data/data_sources/remote/chat_task_remote_data_source.dart' show ChatTaskRemoteDataSource;
import 'package:taskflow/features/chat/domain/repositories/chat_task_repo.dart';

class ChatTaskRepositoryImpl extends ChatTaskRepository{
  final ChatTaskRemoteDataSource chatTaskRemoteDataSource;

  ChatTaskRepositoryImpl(this.chatTaskRemoteDataSource);
  @override
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId) {
    return chatTaskRemoteDataSource.createTask(title, description, assignedToEmail, groupId);
  }

  @override
  Future<void> updateTask(String taskId, String status) {
    return chatTaskRemoteDataSource.updateTask(taskId,status);
  }

}
