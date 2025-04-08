import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/shared/data/models/task_model.dart';

abstract class ChatTaskRemoteDataSource{
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId);
  Future<List<String>> updateTask(String taskId, String status);
}

class ChatTaskRemoteDataSourceImpl extends ChatTaskRemoteDataSource{
  final ApiService _apiService;

  ChatTaskRemoteDataSourceImpl(this._apiService);
  @override
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId) async{
    try{
      final response = await _apiService.request(ApiConstants.createTask, 'POST',body: {
        'title': title,
        'description': description,
        'assignedToEmail': assignedToEmail,
        'groupId': groupId
      });
      return response['_id'];
    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  Future<List<String>> updateTask(String taskId, String status) async{
    try{
      final response = await _apiService.request('${ApiConstants.updateTask}/$taskId', 'PUT',body: {
        'status': status,
      });
      final task = TaskModel.fromJson(response);
      return [task.status,task.id];
    }
    catch(e){
      throw e.toString();
    }
  }

}