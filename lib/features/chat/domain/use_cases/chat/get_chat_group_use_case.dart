
import 'package:taskflow/features/chat/domain/entities/chat_group.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';

class GetChatGroupUseCase{

  final ChatGroupRepository chatGroupRepository;

  GetChatGroupUseCase(this.chatGroupRepository);

  Future<ChatGroup> getChatGroup(String groupId) async {
      return await chatGroupRepository.getGroup(groupId);
  }

}