import 'dart:io';
import 'package:taskflow/features/my_tasks/data/data_sources/my_tasks_remote_data_source.dart';
import 'package:taskflow/features/my_tasks/data/data_sources/my_tasks_local_data_source.dart';
import 'package:taskflow/features/my_tasks/data/mappers/my_task_mapper.dart';
import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';
import 'package:taskflow/features/my_tasks/domain/repositories/my_tasks_repo.dart';

class MyTasksRepositoryImpl extends MyTasksRepository {
  final MyTasksRemoteDataSource myTasksRemoteDataSource;
  final MyTasksLocalDataSource myTasksLocalDataSource;

  MyTasksRepositoryImpl(
      this.myTasksRemoteDataSource,
      this.myTasksLocalDataSource,
      );

  @override
  Future<MyTasks> fetchMyTasks() async {
    try {
      final remoteTasks = await myTasksRemoteDataSource.fetchMyTasks();
      await myTasksLocalDataSource.saveMyTasks(remoteTasks);
      return mapMyTasksModelToEntity(remoteTasks);
    } on SocketException {
      final localTasks = await myTasksLocalDataSource.fetchMyTasks();
      return mapMyTasksModelToEntity(localTasks);
    } catch (e) {
      rethrow;
    }
  }
}
