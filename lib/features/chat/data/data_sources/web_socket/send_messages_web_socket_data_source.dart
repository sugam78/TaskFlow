import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taskflow/core/services/web_socket_service.dart';

abstract class SendMessagesWebSocketDataSource {

  void sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId);

}

class SendMessagesWebSocketDataSourceImpl extends SendMessagesWebSocketDataSource {
  final WebSocketService _webSocketService;

  SendMessagesWebSocketDataSourceImpl(this._webSocketService);

  @override
  void sendMessage(String groupId,String type,String? content,String? fileUrl,String? taskId) {
    IO.Socket socket = _webSocketService.getSocket();
    _webSocketService.connect();
    socket.emit('sendMessage', {
      'groupId': groupId,
      'type': type,
      'taskId': taskId,
      'content': content,
      'fileUrl': fileUrl});
  }
}