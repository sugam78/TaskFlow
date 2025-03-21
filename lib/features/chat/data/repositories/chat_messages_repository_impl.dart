import 'package:taskflow/features/chat/data/data_sources/chat_messages_remote_data_source.dart';
import 'package:taskflow/features/chat/data/mappers/message_mapper.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class ChatMessagesRepositoryImpl extends ChatMessagesRepository{
  final ChatMessagesRemoteDataSource chatMessagesRemoteDataSource;

  ChatMessagesRepositoryImpl(this.chatMessagesRemoteDataSource);
  @override
  Future<Messages> getMessages(String groupId,int page,int limit)async{
    final messages =  await chatMessagesRemoteDataSource.getMessages(groupId,page,limit);
    return mapMessagesToEntity(messages);
  }
  @override
  Future<void> sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId){
    return chatMessagesRemoteDataSource.sendMessage(groupId, type, content, fileUrl, taskId);
  }
}