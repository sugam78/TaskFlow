import 'package:taskflow/features/chat/domain/repositories/send_messages_repo.dart';

class SendMessageUseCase{
  final SendMessagesRepository sendMessagesRepository;

  SendMessageUseCase(this.sendMessagesRepository);

  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId){
    return sendMessagesRepository.sendMessage(groupId, type, content, fileUrl, taskId);
  }
}