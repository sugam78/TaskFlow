import 'dart:io';

import 'package:taskflow/features/chat/data/data_sources/remote/chat_messages_remote_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/web_socket/receive_messages_web_socket_data_source.dart';
import 'package:taskflow/features/chat/data/data_sources/local/chat_messages_local_data_source.dart';
import 'package:taskflow/features/chat/data/mappers/message_mapper.dart';
import 'package:taskflow/features/chat/domain/entities/message.dart';
import 'package:taskflow/features/chat/domain/repositories/chat_messages_repo.dart';

class ChatMessagesRepositoryImpl extends ChatMessagesRepository {
  final ChatMessagesRemoteDataSource chatMessagesRemoteDataSource;
  final ReceiveMessagesWebSocketDataSource receiveMessagesWebSocketDataSource;
  final ChatMessagesLocalDataSource chatMessagesLocalDataSource;

  ChatMessagesRepositoryImpl(
      this.chatMessagesRemoteDataSource,
      this.receiveMessagesWebSocketDataSource,
      this.chatMessagesLocalDataSource,
      );

  @override
  Future<Messages> getMessages(String groupId, int page, int limit) async {
    try {
      final remoteMessages =
      await chatMessagesRemoteDataSource.getMessages(groupId, page, limit);

      await chatMessagesLocalDataSource.saveMessages(groupId, remoteMessages);

      return mapMessagesToEntity(remoteMessages);
    } on SocketException {
      final localMessages =
      await chatMessagesLocalDataSource.getMessages(groupId, page, limit);

      return mapMessagesToEntity(localMessages);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<Message> listenToMessage() {
    return receiveMessagesWebSocketDataSource
        .listenForNewMessages()
        .map(mapMessageToEntity);
  }
}
