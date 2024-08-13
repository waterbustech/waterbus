import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  DrawingBloc() : super(DrawingInitialState()) {
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
    // _sendMessage();
  }

  Future<void> _sendMessage(DrawingModel drawingModel) async {}
}
