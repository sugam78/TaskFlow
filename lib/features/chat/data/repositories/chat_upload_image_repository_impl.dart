import 'dart:io';

import 'package:taskflow/features/chat/data/data_sources/remote/chat_upload_image_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_upload_image_repo.dart';

class ChatUploadImageRepositoryImpl extends ChatUploadImageRepository{
  final ChatUploadImageDataSource chatUploadImageDataSource;

  ChatUploadImageRepositoryImpl(this.chatUploadImageDataSource);
  @override
  Future<String> uploadImage(File file) async{
    return await chatUploadImageDataSource.uploadImage(file);
  }
}