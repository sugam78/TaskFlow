import 'dart:io';

import 'package:taskflow/features/chat/data/data_sources/remote/chat_image_picker_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_image_picker_repo.dart';

class ChatImagePickerRepositoryImpl implements ChatImagePickerRepository {
  final ChatImagePickerDataSource dataSource;

  ChatImagePickerRepositoryImpl(this.dataSource);

  @override
  Future<File?> pickImage() async {
    return await dataSource.pickImage();
  }
}