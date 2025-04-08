
import 'dart:io';

import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatMessagesRemoteDataSource{
  Future<MessagesList> getMessages(String groupId,int page,int limit);
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
    on SocketException{
      throw SocketException('No Internet');
    }
    catch(e){
      throw e.toString();
    }
  }
  
}