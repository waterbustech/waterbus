import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';
import 'package:equatable/equatable.dart';

// import 'package:waterbus_sdk/flutter_waterbus_sdk.dart'; // code not pushed yet

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  // final WaterbusSdk _waterbusSdk = WaterbusSdk.instance; // code not pushed yet
  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingChangedEvent) {
        _sendDraw(event.drawingModel);
        emit(MyDrawingState(event.drawingModel));
      }

      if (event is OnDrawingDeletedEvent) {
        _sendDeleteDraw(event.meetingId);
        // emit(MyDrawingState());
      }

      if (event is OnAnotherDrawingChangedEvent) {
        // emit(AnotherDrawingState(points: event.points));
      }

      if (event is OnAnotherDrawingDeletedEvent) {
        // emit(AnotherDrawingState(points: []));
      }
    });
  }

  // MARK: Private methods
  void _sendDraw(List<DrawingModel?> drawingModel) {
    // _waterbusSdk.sendDraw(meetingId: meetingId); // code not pushed yet
  }
  void _sendDeleteDraw(int meetingId) {
    // _waterbusSdk.deleteDraw(meetingId: meetingId); // code not pushed yet
  }
}
