import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class SendMessageUseCase{
  final ChatMessagesRepository chatMessagesRepository;

  SendMessageUseCase(this.chatMessagesRepository);

  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId){
    return chatMessagesRepository.sendMessage(groupId, type, content, fileUrl, taskId);
  }
}