import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  final IO.Socket socket;

  WebSocketService( this.socket);

  void connect() {
    socket.connect();
    socket.onConnect((_) => print("Connected to WebSocket"));
    socket.onDisconnect((_) => print("Disconnected from WebSocket"));
  }

  IO.Socket getSocket() => socket;

  void disconnect() => socket.disconnect();
}
