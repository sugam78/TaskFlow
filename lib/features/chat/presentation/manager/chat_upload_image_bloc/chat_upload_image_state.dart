part of 'chat_upload_image_bloc.dart';

@immutable
sealed class ChatUploadImageState {}

final class ChatUploadImageInitial extends ChatUploadImageState {}
final class ChatUploadImageLoading extends ChatUploadImageState {}
final class ChatUploadImageLoaded extends ChatUploadImageState {
  final String imageUrl;

  ChatUploadImageLoaded(this.imageUrl);
}
final class ChatUploadImageError extends ChatUploadImageState {
  final String message;

  ChatUploadImageError(this.message);
}
