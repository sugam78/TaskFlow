import 'package:http/http.dart' as http;
import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';

abstract interface class ChatMakeAdminRemoteDataSource{
  Future<void> makeAdmin(String groupId,String email);
}

class ChatMakeAdminRemoteDataSourceImpl extends ChatMakeAdminRemoteDataSource{
  final http.Client client;

  ChatMakeAdminRemoteDataSourceImpl(this.client);
  @override
  Future<void> makeAdmin(String groupId, String email) async{
    try{
      await apiHandler(ApiConstants.makeAdmin, client, 'POST',body: {
        'userEmail': email,
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }

}