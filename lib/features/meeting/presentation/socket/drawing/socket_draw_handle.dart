import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_event.dart';
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';
import 'package:waterbus_sdk/core/websocket/interfaces/socket_handler_interface.dart';

@injectable
class SocketDrawHandle {
  final SocketHandler _webSocket;
  final int _meetingId;
  SocketDrawHandle(this._webSocket, this._meetingId) {
    onListenSocket();
  }
  void onListenSocket() {
    final Socket? socket = _webSocket.socket;

    if (socket == null || !socket.active) return;

    socket.onConnect((_) async {
      socket.on(SocketDrawEvent.updateBoard, (data) {
        if (data == null) return;
        final DrawingModel drawingModel =
            DrawingModel(meetingId: _meetingId, points: data);
        AppBloc.drawingBloc
            .add(OnDrawingChangedEvent(drawingModel: drawingModel));
      });
    });
  }
}
