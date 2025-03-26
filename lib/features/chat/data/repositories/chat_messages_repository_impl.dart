import 'package:taskflow/features/chat/data/data_sources/remote/chat_messages_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/web_socket/receive_messages_web_socket_data_source.dart';
import 'package:taskflow/features/chat/data/mappers/message_mapper.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class ChatMessagesRepositoryImpl extends ChatMessagesRepository{
  final ChatMessagesRemoteDataSource chatMessagesRemoteDataSource;
  final ReceiveMessagesWebSocketDataSource receiveMessagesWebSocketDataSource;

  ChatMessagesRepositoryImpl(this.chatMessagesRemoteDataSource, this.receiveMessagesWebSocketDataSource);
  @override
  Future<Messages> getMessages(String groupId,int page,int limit)async{
    final messages =  await chatMessagesRemoteDataSource.getMessages(groupId,page,limit);
    return mapMessagesToEntity(messages);
  }


  @override
  Stream<Message> listenToMessage() {
    return receiveMessagesWebSocketDataSource.listenForNewMessages().map((msgModel){
      return mapMessageToEntity(msgModel);
    });
  }
}