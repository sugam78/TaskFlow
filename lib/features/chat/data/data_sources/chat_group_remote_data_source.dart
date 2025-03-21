import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/chat/data/models/chat_group_model.dart';
import 'package:taskflow/features/chat/data/models/my_chat_groups_model.dart';
import 'package:http/http.dart' as http;

abstract class ChatGroupRemoteDataSource{
  Future<MyChatGroupsModel> getMyGroups();
  Future<bool> createGroup(String name, List<String> memberEmails);
  Future<ChatGroupModel> getGroup(String groupId);
}

class ChatGroupRemoteDataSourceImpl extends ChatGroupRemoteDataSource{
  final http.Client client;

  ChatGroupRemoteDataSourceImpl(this.client);
  @override
  Future<MyChatGroupsModel> getMyGroups()async{
    try{
      final response = await apiHandler(ApiConstants.getMyGroups, client, 'GET');
      if(response.toString()=='[]'){
        throw 'No groups associated with you';
      }
      final groups = MyChatGroupsModel.fromJson(response);
      return groups;
    }
    catch(e){
      throw 'Error: $e';
    }
  }
  @override
  Future<bool> createGroup(String name, List<String> memberEmails)async{
    try{
      final response = await apiHandler(ApiConstants.createGroup, client,'POST',body: {
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
      final response = await apiHandler('${ApiConstants.getGroup}/$groupId', client,'GET');

      final group = ChatGroupModel.fromJson(response);
      return group;
    }
    catch(e){
      throw Exception('Error: $e');
    }
  }
}