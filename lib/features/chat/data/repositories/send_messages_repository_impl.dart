
import 'package:taskflow/features/chat/data/data_sources/web_socket/send_messages_web_socket_data_source.dart';
import 'package:taskflow/features/chat/domain/repositories/send_messages_repo.dart';

class SendMessagesRepositoryImpl extends SendMessagesRepository {
  final SendMessagesWebSocketDataSource sendMessagesWebSocketDataSource;

  SendMessagesRepositoryImpl(
      this.sendMessagesWebSocketDataSource,
      );

  @override
  Future<void> sendMessage(
      String groupId, String type, String? content, String? fileUrl, String? taskId) async {


    sendMessagesWebSocketDataSource.sendMessage(
        groupId, type, content, fileUrl, taskId);

  }
}
