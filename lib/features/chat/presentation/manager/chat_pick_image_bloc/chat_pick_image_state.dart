part of 'chat_pick_image_bloc.dart';

@immutable
sealed class ChatPickImageState {}

final class ChatPickImageInitial extends ChatPickImageState {}
final class ChatPickImageLoading extends ChatPickImageState {}
final class ChatPickImageLoaded extends ChatPickImageState {
  final File imageFIle;

  ChatPickImageLoaded(this.imageFIle);
}
final class ChatPickImageError extends ChatPickImageState {
  final String message;

  ChatPickImageError(this.message);
}
