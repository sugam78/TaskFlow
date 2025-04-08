
import 'dart:io';

import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';

abstract class ChatMessagesRemoteDataSource{
  Future<MessagesList> getMessages(String groupId,int page,int limit);
}

class ChatMessagesRemoteDataSourceImpl extends ChatMessagesRemoteDataSource{
  final ApiService _apiService;

  ChatMessagesRemoteDataSourceImpl(this._apiService);
  @override
  Future<MessagesList> getMessages(String groupId,int page,int limit) async{
    try{
      final response = await _apiService.request('${ApiConstants.fetchMessage}/$groupId?page=$page&limit=$limit', 'GET');
      final messages = MessagesList.fromJson(response);
      return messages;
    }
    on SocketException{
      throw SocketException('No Internet');
    }
    catch(e){
      throw e.toString();
    }
  }
  
}