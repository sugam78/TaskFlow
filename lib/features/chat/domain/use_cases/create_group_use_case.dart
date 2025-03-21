import 'package:taskflow/features/chat/domain/repositories/chat_group_repo.dart';

class CreateGroupUseCase{
  final ChatGroupRepository chatGroupRepository;

  CreateGroupUseCase(this.chatGroupRepository);

  Future<bool> createGroup(String name,List<String> memberEmails)async{
    return chatGroupRepository.createGroup(name, memberEmails);
  }
}