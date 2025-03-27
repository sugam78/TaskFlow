import 'package:taskflow/features/my_tasks/data/models/my_tasks_model.dart';
import 'package:taskflow/features/my_tasks/domain/entities/my_tasks.dart';
import 'package:taskflow/shared/domain/entities/task.dart';

MyTasks mapMyTasksModelToEntity(MyTasksModel model) {
  return MyTasks(
    taskList: model.tasks.map((task) => Task(
      id: task.id,
      title: task.title,
      description: task.description,
      assignedTo: task.assignedTo,
      status: task.status,
      dueDate: task.dueDate,
      createdBy: task.createdBy,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    )).toList(),
  );
}