import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';

abstract interface class ChatMemberRemoteDataSource{
  Future<void> addMember(String groupId,String email);
  Future<void> removeMember(String groupId,String email);
}

class ChatMemberRemoteDataSourceImpl extends ChatMemberRemoteDataSource{
  final ApiService apiService;

  ChatMemberRemoteDataSourceImpl(this.apiService);
  @override
  Future<void> addMember(String groupId, String email) async{
    try{
      await apiService.request(ApiConstants.addMember, 'POST',body: {
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
      await apiService.request(ApiConstants.removeMember, 'POST',body: {
        'userEmail': email,
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }
}