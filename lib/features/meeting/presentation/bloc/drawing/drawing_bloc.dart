import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';
// import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  // final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;
  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingChangedEvent) {
        _sendDraw(event.drawingModel);
        emit(MyDrawingState(drawingModel: event.drawingModel));
      }

      if (event is OnDrawingDeletedEvent) {
        // _waterbusSdk.deleteDraw(meetingId: meetingId);
        final DrawingModel drawingModel =
            DrawingModel(meetingId: event.meetingId, points: []);
        emit(MyDrawingState(drawingModel: drawingModel));
      }
    });
  }
  void _sendDraw(DrawingModel drawingModel) {}
}
