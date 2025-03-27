
import 'package:taskflow/shared/domain/repositories/chat_task_repo.dart';

class UpdateTaskUseCase{
  final ChatTaskRepository chatTaskRepository;

  UpdateTaskUseCase(this.chatTaskRepository);

  Future<List<String>> updateTask(String taskId,String status)async{
     return await chatTaskRepository.updateTask(taskId, status);
  }
}