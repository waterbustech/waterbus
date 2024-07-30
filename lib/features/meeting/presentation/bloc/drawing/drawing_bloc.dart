import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_event.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_handle.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final SocketDrawHandle _socketDrawHandle;

  DrawingBloc(this._socketDrawHandle) : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingChangedEvent) {
        _hanldeChangeDraw();

        emit(DrawingChangedState(points: event.points));
      }

      if (event is OnDrawingDeletedEvent) {
        emit(DrawingChangedState(points: []));
      }
    });
  }
  void _hanldeChangeDraw() {
    _socketDrawHandle.onSendSocket(SocketDrawEvent.updateBoard);
  }
}
