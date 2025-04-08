

import 'dart:io';

import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:taskflow/core/constants/api_constants.dart';
import 'package:taskflow/features/my_tasks/data/models/my_tasks_model.dart';
import 'package:http/http.dart' as http;

abstract class MyTasksRemoteDataSource{
  Future<MyTasksModel> fetchMyTasks();
}

class MyTasksRemoteDataSourceImpl extends MyTasksRemoteDataSource{
  final http.Client client;

  MyTasksRemoteDataSourceImpl(this.client);
  @override
  Future<MyTasksModel> fetchMyTasks() async{
    try{
      final response = await apiHandler(ApiConstants.myTasks, client, 'GET');
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