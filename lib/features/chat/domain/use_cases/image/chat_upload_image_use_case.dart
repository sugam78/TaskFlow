import 'dart:io';

import 'package:taskflow/features/chat/domain/repositories/chat_upload_image_repo.dart';

class ChatUploadImageUseCase{
  final ChatUploadImageRepository chatUploadImageRepository;

  ChatUploadImageUseCase(this.chatUploadImageRepository);
  Future<String> uploadImage(File file)async{
    return await chatUploadImageRepository.uploadImage(file);
  }
}