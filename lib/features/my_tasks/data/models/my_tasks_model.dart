import 'package:hive/hive.dart';
import 'package:taskflow/shared/data/models/task_model.dart';

part 'my_tasks_model.g.dart';

@HiveType(typeId: 8)
class MyTasksModel {
  @HiveField(0)
  final List<TaskModel> tasks;

  MyTasksModel({required this.tasks});

  factory MyTasksModel.fromJson(List<dynamic> jsonList) {
    return MyTasksModel(
      tasks: jsonList.map((task) => TaskModel.fromJson(task)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return tasks.map((task) => task.toJson()).toList();
  }
}
