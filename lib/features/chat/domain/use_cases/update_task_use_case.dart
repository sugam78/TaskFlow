import 'package:taskflow/features/chat/domain/repositories/chat_task_repo.dart';

class UpdateTaskUseCase{
  final ChatTaskRepository chatTaskRepository;

  UpdateTaskUseCase(this.chatTaskRepository);

  Future<void> updateTask(String taskId,String status)async{
     await chatTaskRepository.updateTask(taskId, status);
  }
}