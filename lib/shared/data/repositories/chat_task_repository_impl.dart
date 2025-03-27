
import 'package:taskflow/shared/data/data_sources/chat_task_remote_data_source.dart';
import 'package:taskflow/shared/domain/repositories/chat_task_repo.dart';

class ChatTaskRepositoryImpl extends ChatTaskRepository{
  final ChatTaskRemoteDataSource chatTaskRemoteDataSource;

  ChatTaskRepositoryImpl(this.chatTaskRemoteDataSource);
  @override
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId) {
    return chatTaskRemoteDataSource.createTask(title, description, assignedToEmail, groupId);
  }

  @override
  Future<List<String>> updateTask(String taskId, String status) {
    return chatTaskRemoteDataSource.updateTask(taskId,status);
  }

}
