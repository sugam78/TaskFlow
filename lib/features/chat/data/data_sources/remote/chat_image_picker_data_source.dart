import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class ChatImagePickerDataSource {
  Future<File?> pickImage();
}

class ChatImagePickerDataSourceImpl implements ChatImagePickerDataSource {
  final ImagePicker _imagePicker;

  ChatImagePickerDataSourceImpl(this._imagePicker);

  @override
  Future<File?> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
