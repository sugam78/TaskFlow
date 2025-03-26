
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class ListenToMessageUseCase {
  final ChatMessagesRepository chatMessagesRepository;

  ListenToMessageUseCase(this.chatMessagesRepository);

  Stream<Message> listenToMessage(){
    return chatMessagesRepository.listenToMessage();
}
}