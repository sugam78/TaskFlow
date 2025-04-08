
import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';


abstract interface class ChangePasswordRemoteDataSource{
  Future<void> changePassword(String currentPassword,String newPassword);
}

class ChangePasswordRemoteDataSourceImpl extends ChangePasswordRemoteDataSource{
  final ApiService _apiService;

  ChangePasswordRemoteDataSourceImpl(this._apiService);
  @override
  Future<void> changePassword(String currentPassword, String newPassword) async{
    try{
      await _apiService.request(ApiConstants.changePassword, 'POST',body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword
      });
    }
    catch(e){
      throw '$e';
    }
  }

}