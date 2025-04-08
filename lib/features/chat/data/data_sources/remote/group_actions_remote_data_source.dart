import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';


abstract interface class GroupActionsRemoteDataSource {
  Future<void> leaveGroup(String groupId);
}

class GroupActionsRemoteDataSourceImpl extends GroupActionsRemoteDataSource{
  final ApiService _apiService;

  GroupActionsRemoteDataSourceImpl(this._apiService);
  @override
  Future<void> leaveGroup(String groupId) async{
    try{
      await _apiService.request(ApiConstants.leaveGroup, 'POST',body: {
        'groupId': groupId
      });
    }
    catch(e){
      throw e.toString();
    }
  }
}
