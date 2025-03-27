import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';
import 'package:taskflow/features/my_tasks/domain/repositories/my_tasks_repo.dart';

class FetchMyTasksUseCase{
  final MyTasksRepository myTasksRepository;

  FetchMyTasksUseCase(this.myTasksRepository);

  Future<MyTasks> fetchMyTasks(){
    return myTasksRepository.fetchMyTasks();
}
}