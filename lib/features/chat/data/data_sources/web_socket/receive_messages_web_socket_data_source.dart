import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taskflow/core/services/web_socket_service.dart';
import 'package:taskflow/features/chat/data/models/messages_model.dart';

abstract class ReceiveMessagesWebSocketDataSource {
  Stream<MessageModel> listenForNewMessages();
}

class ReceiveMessagesWebSocketDataSourceImpl extends ReceiveMessagesWebSocketDataSource {
  final WebSocketService _webSocketService;
  final StreamController<MessageModel> _messageStreamController;

  ReceiveMessagesWebSocketDataSourceImpl(this._webSocketService, this._messageStreamController) {
    _initializeListener();
  }

  void _initializeListener() {
    IO.Socket socket = _webSocketService.getSocket();
    _webSocketService.connect();
    socket.on('newMessage', (data) {
      final message = MessageModel.fromJson(data);
      _messageStreamController.add(message);
    });
  }

  @override
  Stream<MessageModel> listenForNewMessages() {
    return _messageStreamController.stream;
  }
}
