import 'dart:io';

import 'package:taskflow/features/chat/domain/repositories/chat_image_picker_repo.dart';

class ChatImagePickerUseCase {
  final ChatImagePickerRepository chatImagePickerRepository;

  ChatImagePickerUseCase(this.chatImagePickerRepository);
  Future<File?> pickImage(){
    return chatImagePickerRepository.pickImage();
  }
}