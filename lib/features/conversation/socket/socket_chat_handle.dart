import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
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

        final MessageModel message = MessageModel.fromMap(data);

        if (message.createdBy?.id == AppBloc.userBloc.user?.id) return;

        AppBloc.messageBloc.add(InsertMessageEvent(message: message));
      });

      socket.on(SocketChatEvent.updateMessageSSC, (data) {
        if (data == null) return;

        final MessageModel message = MessageModel.fromMap(data);

        if (message.createdBy?.id == AppBloc.userBloc.user?.id) return;

        AppBloc.messageBloc.add(
          UpdateMessageFromSocketEvent(
            messageId: message.id,
            meetingId: message.meeting,
            data: message.data,
          ),
        );
      });
      socket.on(SocketChatEvent.deleteMessageSSC, (data) {
        if (data == null) return;

        final MessageModel message = MessageModel.fromMap(data);

        if (message.createdBy?.id == AppBloc.userBloc.user?.id) return;

        AppBloc.messageBloc.add(
          UpdateMessageFromSocketEvent(
            messageId: message.id,
            meetingId: message.meeting,
          ),
        );
      });
    });
  }
}
