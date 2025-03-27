

import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';

abstract class MyTasksRepository{
  Future<MyTasks> fetchMyTasks();
}