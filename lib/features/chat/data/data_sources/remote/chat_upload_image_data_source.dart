import 'dart:io';

import 'package:taskflow/core/common/services/api_services.dart';

import 'package:taskflow/core/constants/api_constants.dart';

abstract class ChatUploadImageDataSource{
  Future<String> uploadImage(File file);
}

class ChatUploadImageDataSourceImpl extends ChatUploadImageDataSource{
  final ApiService _apiService;

  ChatUploadImageDataSourceImpl(this._apiService);
  @override
  Future<String> uploadImage(File file) async{
    try{
      final response = await _apiService.request(ApiConstants.uploadImage, 'POST',file: file);
      return response['url'];
    }
    catch(e){
      throw e.toString();
    }
  }
  
}