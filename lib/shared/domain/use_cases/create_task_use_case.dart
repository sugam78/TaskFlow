import 'package:taskflow/shared/domain/repositories/chat_task_repo.dart';

class CreateTaskUseCase{
  final ChatTaskRepository chatTaskRepository;

  CreateTaskUseCase(this.chatTaskRepository);

  Future<String> createTask(String title,String description,String assignedToEmail, String groupId)async{
    return await chatTaskRepository.createTask(title, description, assignedToEmail, groupId);
  }
}