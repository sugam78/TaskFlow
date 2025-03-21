import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/core/constants/api_constants.dart';

abstract class ChatTaskRemoteDataSource{
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId);
  Future<void> updateTask(String taskId, String status);
}

class ChatTaskRemoteDataSourceImpl extends ChatTaskRemoteDataSource{
  final http.Client client;

  ChatTaskRemoteDataSourceImpl(this.client);
  @override
  Future<String> createTask(String title, String description, String assignedToEmail, String groupId) async{
    try{
      final response = await apiHandler(ApiConstants.createTask, client, 'POST',body: {
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
  Future<void> updateTask(String taskId, String status) async{
    try{
     await apiHandler('${ApiConstants.updateTask}/$taskId', client, 'PUT',body: {
        'status': status,
      });
    }
    catch(e){
      throw e.toString();
    }
  }

}