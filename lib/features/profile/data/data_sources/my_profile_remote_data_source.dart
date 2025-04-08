import 'dart:io';

import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/profile/data/models/profile_model.dart';

abstract interface class MyProfileRemoteDataSource{
  Future<ProfileModel> getMyProfile();
}

class MyProfileRemoteDataSourceImpl extends MyProfileRemoteDataSource{
  final ApiService _apiService;

  MyProfileRemoteDataSourceImpl(this._apiService);
  @override
  Future<ProfileModel> getMyProfile()async {
   try{
     final response = await _apiService.request(ApiConstants.myProfile, 'GET');
     print(response);
     return ProfileModel.fromJson(response);
   }
   on SocketException{
     throw SocketException('No Internet Connection');
   }
   catch(e){
     throw e.toString();
   }
  }

}