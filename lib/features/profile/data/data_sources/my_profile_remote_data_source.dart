import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/profile/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

abstract interface class MyProfileRemoteDataSource{
  Future<ProfileModel> getMyProfile();
}

class MyProfileRemoteDataSourceImpl extends MyProfileRemoteDataSource{
  final http.Client client;

  MyProfileRemoteDataSourceImpl(this.client);
  @override
  Future<ProfileModel> getMyProfile()async {
   try{
     final response = await apiHandler(ApiConstants.myProfile, client, 'GET');
     return ProfileModel.fromJson(response);
   }
   catch(e){
     throw e.toString();
   }
  }

}