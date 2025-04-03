import 'package:taskflow/features/chat/domain/repositories/chat_member_repo.dart';

class RemoveMemberUseCase{
  final ChatMemberRepository chatMemberRepository;

  RemoveMemberUseCase(this.chatMemberRepository);

  Future<void> removeMember(String groupId,String email)async{
    return await chatMemberRepository.removeMember(groupId, email);
  }
}