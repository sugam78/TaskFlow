part of 'chat_upload_image_bloc.dart';

@immutable
sealed class ChatUploadImageEvent {}

final class ChatUploadImage extends ChatUploadImageEvent{
  final File file;

  ChatUploadImage(this.file);
}

final class ResetUploadImage extends ChatUploadImageEvent{}
