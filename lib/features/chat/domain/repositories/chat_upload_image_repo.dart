import 'dart:io';

abstract class ChatUploadImageRepository{
  Future<String> uploadImage(File file);
}