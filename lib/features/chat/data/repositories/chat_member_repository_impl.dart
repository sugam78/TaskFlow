import 'package:taskflow/features/chat/data/data_sources/remote/chat_member_remote_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_member_repo.dart';

class ChatMemberRepositoryImpl extends ChatMemberRepository{
  final ChatMemberRemoteDataSource chatAddMemberRemoteDataSource;

  ChatMemberRepositoryImpl(this.chatAddMemberRemoteDataSource);
  @override
  Future<void> addMember(String groupId, String email) async{
    return await chatAddMemberRemoteDataSource.addMember(groupId, email);
  }

  @override
  Future<void> removeMember(String groupId, String email) async{
    return await chatAddMemberRemoteDataSource.removeMember(groupId, email);
  }

}