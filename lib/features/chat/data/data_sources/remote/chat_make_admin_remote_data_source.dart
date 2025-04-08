import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';

abstract interface class ChatMakeAdminRemoteDataSource{
  Future<void> makeAdmin(String groupId,String email);
}

class ChatMakeAdminRemoteDataSourceImpl extends ChatMakeAdminRemoteDataSource{
  final ApiService apiService;

  ChatMakeAdminRemoteDataSourceImpl(this.apiService);
  @override
  Future<void> makeAdmin(String groupId, String email) async{
    try{
      await apiService.request(ApiConstants.makeAdmin, 'POST',body: {
        'userEmail': email,
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }

}