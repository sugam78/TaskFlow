import 'dart:io';

abstract class ChatImagePickerRepository {
  Future<File?> pickImage();
}