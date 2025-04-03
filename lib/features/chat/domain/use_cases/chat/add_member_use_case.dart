import 'package:taskflow/features/chat/domain/repositories/chat_member_repo.dart';

class AddMemberUseCase{
  final ChatMemberRepository chatAddMemberRepository;

  AddMemberUseCase(this.chatAddMemberRepository);

  Future<void> addMember(String groupId,String email)async{
    return await chatAddMemberRepository.addMember(groupId, email);
  }
}