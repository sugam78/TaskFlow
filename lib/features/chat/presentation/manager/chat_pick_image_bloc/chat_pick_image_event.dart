part of 'chat_pick_image_bloc.dart';

@immutable
sealed class ChatPickImageEvent {}

final class ChatPickImage extends ChatPickImageEvent{}
final class ResetPickImage extends ChatPickImageEvent{}
