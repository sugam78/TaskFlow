import 'dart:io';

import 'package:taskflow/core/common/services/api_handler.dart';
import 'package:http/http.dart' as http;
import 'package:taskflow/core/constants/api_constants.dart';

abstract class ChatUploadImageDataSource{
  Future<String> uploadImage(File file);
}

class ChatUploadImageDataSourceImpl extends ChatUploadImageDataSource{
  final http.Client client;

  ChatUploadImageDataSourceImpl(this.client);
  @override
  Future<String> uploadImage(File file) async{
    try{
      final response = await apiHandler(ApiConstants.uploadImage, client, 'POST',file: file);
      return response['url'];
    }
    catch(e){
      throw e.toString();
    }
  }
  
}