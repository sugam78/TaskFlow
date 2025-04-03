import 'package:taskflow/features/chat/data/data_sources/remote/chat_make_admin_remote_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_make_admin_repo.dart';

class ChatMakeAdminRepositoryImpl extends ChatMakeAdminRepository{
  final ChatMakeAdminRemoteDataSource chatMakeAdminRemoteDataSource;

  ChatMakeAdminRepositoryImpl(this.chatMakeAdminRemoteDataSource);
  @override
  Future<void> makeAdmin(String groupId, String email) async{
    return await chatMakeAdminRemoteDataSource.makeAdmin(groupId, email);
  }

}