import 'package:taskflow/features/chat/domain/entities/my_chat_groups.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';

class GetMyGroupsUseCase {
  final ChatGroupRepository chatGroupRepository;

  GetMyGroupsUseCase(this.chatGroupRepository);

  Future<MyChatGroups> getMyGroups() async {
    return await chatGroupRepository.getMyGroups();
  }
}
