import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/core/utils/json_parser.dart';
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';

abstract class ChatGroupRemoteDataSource{
  Future<MyChatGroupsModel> getMyGroups();
  Future<bool> createGroup(String name, List<String> memberEmails);
  Future<ChatGroupModel> getGroup(String groupId);
}

class ChatGroupRemoteDataSourceImpl extends ChatGroupRemoteDataSource{
  final ApiService apiService;

  ChatGroupRemoteDataSourceImpl(this.apiService);
  @override
  Future<MyChatGroupsModel> getMyGroups()async{
    try{
      final response = await apiService.request(ApiConstants.getMyGroups,'GET');
      if(response.toString()=='[]'){
        throw 'No groups associated with you';
      }
      final groups = await compute(parseGroups, jsonEncode(response));

      return groups;
    }
    on SocketException{
      throw SocketException('No Internet');
    }
    catch(e){
      throw 'Error: $e';
    }
  }
  @override
  Future<bool> createGroup(String name, List<String> memberEmails)async{
    try{
      final response = await apiService.request(ApiConstants.createGroup,'POST',body: {
        'name': name,
        'memberEmails': memberEmails
      });
      final newGroup = ChatGroupItem.fromJson(response);
      if(newGroup.name == name){
        return true;
      }
      return false;
    }

    catch(e){
      throw Exception('Error: $e');
    }
  }
  @override
  Future<ChatGroupModel> getGroup(String groupId)async{
    try{
      final response = await apiService.request('${ApiConstants.getGroup}/$groupId','GET');

      final group = ChatGroupModel.fromJson(response);
      return group;
    }
    on SocketException{
      throw SocketException('No Internet');
    }
    catch(e){
      throw Exception('Error: $e');
    }
  }
}