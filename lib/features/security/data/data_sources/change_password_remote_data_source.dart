
import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;


abstract interface class ChangePasswordRemoteDataSource{
  Future<void> changePassword(String currentPassword,String newPassword);
}

class ChangePasswordRemoteDataSourceImpl extends ChangePasswordRemoteDataSource{
  final http.Client client;

  ChangePasswordRemoteDataSourceImpl(this.client);
  @override
  Future<void> changePassword(String currentPassword, String newPassword) async{
    try{
      await apiHandler(ApiConstants.changePassword, client, 'POST',body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword
      });
    }
    catch(e){
      throw '$e';
    }
  }

}