import 'package:taskflow/features/chat/domain/repositories/chat_make_admin_repo.dart';

class MakeGroupAdminUseCase{
  final ChatMakeAdminRepository chatMakeAdminRepository;

  MakeGroupAdminUseCase(this.chatMakeAdminRepository);

  Future<void> makeAdmin(String groupId, String email) async{
    return await chatMakeAdminRepository.makeAdmin(groupId, email);
  }
}