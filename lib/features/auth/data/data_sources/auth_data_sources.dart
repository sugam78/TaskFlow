
import 'package:taskflow/core/common/services/api_handler.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signUp(String name,String email, String password,String token);
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {

  AuthRemoteDataSourceImpl();



  @override
  Future<void> signUp(String name,String email, String password,String fcmToken) async {
    try {
      await apiHandler(ApiConstants.signUp, 'POST',body: {
        'name':name,
        'email':email,
        'password':password,
        'fcmToken':fcmToken
      });
    }
    catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try{
      final response = await apiHandler(ApiConstants.login, 'POST',body: {
        'email': email,
        'password': password
      });
      final user = UserModel.fromJson(response);
      return user;
    }
    catch(e){
      throw Exception('$e');
    }
  }
}
