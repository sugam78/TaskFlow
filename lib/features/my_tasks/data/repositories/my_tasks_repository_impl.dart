import 'package:taskflow/features/my_tasks/data/data_sources/my_tasks_remote_data_source.dart';
import 'package:taskflow/features/my_tasks/data/mappers/my_task_mapper.dart';
import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';
import 'package:taskflow/features/my_tasks/domain/repositories/my_tasks_repo.dart';


class MyTasksRepositoryImpl extends MyTasksRepository{
  final MyTasksRemoteDataSource myTasksRemoteDataSource;

  MyTasksRepositoryImpl(this.myTasksRemoteDataSource);
  @override
  Future<MyTasks> fetchMyTasks() async{
    final tasks = await myTasksRemoteDataSource.fetchMyTasks();
    return mapMyTasksModelToEntity(tasks);
  }
}