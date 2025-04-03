import 'package:http/http.dart' as http;
import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';

abstract interface class ChatMemberRemoteDataSource{
  Future<void> addMember(String groupId,String email);
  Future<void> removeMember(String groupId,String email);
}

class ChatMemberRemoteDataSourceImpl extends ChatMemberRemoteDataSource{
  final http.Client client;

  ChatMemberRemoteDataSourceImpl(this.client);
  @override
  Future<void> addMember(String groupId, String email) async{
    try{
      await apiHandler(ApiConstants.addMember, client, 'POST',body: {
        'userEmail': email,
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  Future<void> removeMember(String groupId, String email) async{
    try{
      await apiHandler(ApiConstants.removeMember, client, 'POST',body: {
        'userEmail': email,
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }
}