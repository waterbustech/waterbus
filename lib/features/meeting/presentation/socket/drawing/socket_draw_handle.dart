import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_event.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';

@injectable
class SocketDrawHandle {
  final SocketHandler _webSocket;
  SocketDrawHandle(this._webSocket);
  void onListenSocket() {
    final Socket? socket = _webSocket.socket;

    if (socket == null || !socket.active) return;

    socket.onConnect((_) async {
      socket.on(SocketDrawEvent.updateBoard, (data) {
        if (data == null) return;

        AppBloc.drawingBloc.add(OnDrawingChangedEvent(points: []));
        print(data);
      });
    });
  }

  void onSendSocket(String event) {
    final Socket? socket = _webSocket.socket;
    if (socket == null || !socket.active) return;
    socket.onConnect((_) async {
      socket.emit(event);
    });
  }
}
