
import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatMessagesRemoteDataSource{
  Future<MessagesList> getMessages(String groupId,int page,int limit);
  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId);
}

class ChatMessagesRemoteDataSourceImpl extends ChatMessagesRemoteDataSource{
  final http.Client client;

  ChatMessagesRemoteDataSourceImpl(this.client);
  @override
  Future<MessagesList> getMessages(String groupId,int page,int limit) async{
    try{
      final response = await apiHandler('${ApiConstants.fetchMessage}/$groupId?page=$page&limit=$limit', client, 'GET');
      final messages = MessagesList.fromJson(response);
      return messages;
    }
    catch(e){
      throw e.toString();
    }
  }
//content, taskId, fileUrl, groupId, type
  @override
  Future<void> sendMessage(String groupId, String type, String? content, String? fileUrl, String? taskId) async{
    try{
      await apiHandler(ApiConstants.sendMessage, client, 'POST',body: {
        'groupId': groupId,
        'type': type,
        'taskId': taskId,
        'content': content,
        'fileUrl': fileUrl
      });
    }
    catch(e){
      throw e.toString();
    }
  }
  
}