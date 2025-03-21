import 'package:taskflow/features/chat/domain/entities/message.dart';

abstract class ChatMessagesRepository{
  Future<Messages> getMessages(String groupId,int page,int limit);
  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId);
}