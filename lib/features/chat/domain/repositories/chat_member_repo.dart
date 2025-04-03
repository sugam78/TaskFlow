abstract class ChatMemberRepository{
  Future<void> addMember(String groupId,String email);
  Future<void> removeMember(String groupId,String email);
}