import 'package:taskflow/shared/data/models/task_model.dart';

class MyTasksModel {
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
