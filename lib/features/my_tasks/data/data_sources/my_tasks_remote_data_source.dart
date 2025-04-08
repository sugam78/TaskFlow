

import 'dart:io';

import 'package:taskflow/core/common/services/api_services.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/my_tasks/data/models/my_tasks_model.dart';

abstract class MyTasksRemoteDataSource{
  Future<MyTasksModel> fetchMyTasks();
}

class MyTasksRemoteDataSourceImpl extends MyTasksRemoteDataSource{
  final ApiService _apiService;

  MyTasksRemoteDataSourceImpl(this._apiService);
  @override
  Future<MyTasksModel> fetchMyTasks() async{
    try{
      final response = await _apiService.request(ApiConstants.myTasks, 'GET');
      return MyTasksModel.fromJson(response);
    }
    on SocketException{
      throw SocketException('No Internet Connection');
    }
    catch(e){
      throw e.toString();
    }
  }

}