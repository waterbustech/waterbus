import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';

import 'package:waterbus/features/conversation/socket/socket_chat_event.dart';

@injectable
class SocketChatHandle {
  final SocketHandler _webSocket;

  SocketChatHandle(this._webSocket);

  void onListenSocket() {
    final Socket? socket = _webSocket.socket;

    if (socket == null || !socket.active) return;

    socket.onConnect((_) async {
      socket.on(SocketChatEvent.sendMessageSSC, (data) {
        if (data == null) return;

        // print("sendMessageSSC: $data");
      });

      socket.on(SocketChatEvent.updateMessageSSC, (data) {
        if (data == null) return;

        // print("updateMessageSSC: $data");
      });
      socket.on(SocketChatEvent.deleteMessageSSC, (data) {
        if (data == null) return;

        // print("deleteMessageSSC: $data");
      });
    });
  }
}
