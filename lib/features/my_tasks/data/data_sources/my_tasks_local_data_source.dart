import 'package:hive/hive.dart';
import 'package:taskflow/features/my_tasks/data/models/my_tasks_model.dart';

abstract class MyTasksLocalDataSource {
  Future<MyTasksModel> fetchMyTasks();
  Future<void> saveMyTasks(MyTasksModel myTasks);
}

class MyTasksLocalDataSourceImpl extends MyTasksLocalDataSource {
  final Box _box = Hive.box('MyTasks');

  @override
  Future<MyTasksModel> fetchMyTasks() async {
    final data = _box.get('my_tasks');
    if (data != null && data is MyTasksModel) {
      return data;
    } else {
      throw "No Internet connection";
    }
  }

  @override
  Future<void> saveMyTasks(MyTasksModel myTasks) async {
    await _box.put('my_tasks', myTasks);
  }
}
