import 'package:taskflow/features/chat/domain/entities/message.dart';

abstract class ChatMessagesRepository{
  Future<Messages> getMessages(String groupId,int page,int limit);
  Stream<Message> listenToMessage();
}