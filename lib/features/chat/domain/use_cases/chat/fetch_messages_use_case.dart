import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class FetchMessageUseCase {
  final ChatMessagesRepository chatMessagesRepository;

  FetchMessageUseCase(this.chatMessagesRepository);

  Future<Messages> fetchMessages(String groupId,int page,int limit)async{
    return chatMessagesRepository.getMessages(groupId, page, limit);
  }
}