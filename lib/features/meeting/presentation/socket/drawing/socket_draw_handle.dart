import 'package:socket_io_client/socket_io_client.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/handle_socket/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_event.dart';

class SocketDrawHandle {
  final Socket? socket;
  SocketDrawHandle(this.socket) {
    onListenSocket(socket);
  }
  void onListenSocket(Socket? socket) {
    if (socket == null || !socket.active) return;

    socket.onConnect((_) async {
      socket.on(SocketDrawEvent.updateBoard, (data) {
        if (data == null) return;
        AppBloc.drawingBloc.add(
          OnAnotherDrawingChangedEvent(points: data),
        );
      });

      socket.on(SocketDrawEvent.deleteBoard, (data) {
        if (data == null) return;
        AppBloc.drawingBloc.add(
          OnAnotherDrawingDeletedEvent(),
        );
      });
    });
  }
}
