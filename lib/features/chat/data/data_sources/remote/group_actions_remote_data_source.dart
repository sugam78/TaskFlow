import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

abstract interface class GroupActionsRemoteDataSource {
  Future<void> leaveGroup(String groupId);
}

class GroupActionsRemoteDataSourceImpl extends GroupActionsRemoteDataSource{
  final http.Client client;

  GroupActionsRemoteDataSourceImpl(this.client);
  @override
  Future<void> leaveGroup(String groupId) async{
    try{
      await apiHandler(ApiConstants.leaveGroup, client, 'POST',body: {
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }
}
