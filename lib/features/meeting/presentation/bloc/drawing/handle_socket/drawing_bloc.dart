import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/features/meeting/domain/models/stroke.dart';
import 'package:waterbus/features/meeting/presentation/notifiers/current_stroke_value_notifier.dart';

// ignore: unused_import
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';

// import 'package:waterbus_sdk/flutter_waterbus_sdk.dart'; // code not pushed yet

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  // final WaterbusSdk _waterbusSdk = WaterbusSdk.instance; // code not pushed yet
  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      if (event is OnDrawingChangedEvent) {
        // Kiểm tra xem state hiện tại có phải là LocalDrawingState không
        if (state is LocalDrawingState) {
          final currentState =
              state as LocalDrawingState; // An toàn hơn khi ép kiểu
          final newState =
              currentState.addStroke(event.drawingModel); // Thêm Stroke mới
          emit(newState); // Phát ra trạng thái mới
        } else {
          emit(
            LocalDrawingState(localProps: [event.drawingModel]),
          ); // Khởi tạo với Stroke mới
        }
      }

      if (event is OnDrawingDeletedEvent) {
        _sendDeleteDraw(event.meetingId);
        // emit(MyDrawingState([]));
      }


      if (event is OnAnotherDrawingChangedEvent) {
        // emit(AnotherDrawingState(points: event.points));
      }

      if (event is OnAnotherDrawingDeletedEvent) {
        // emit(AnotherDrawingState(points: []));
      }
    });
  }
  // void _onDrawingInit(OnDrawingChangedEvent event, Emitter<DrawingState> emit) {
  //   // Create a new stroke based on the provided stroke type
  //   // final Stroke newStroke = _createStroke(event);
  //   state.localProps.add(newStroke);
  //   emit(LocalDrawingState(drawingModel: state.localProps));
  // }

  // Stroke _createStroke(OnDrawingChangedEvent event) {
  //   switch (event.drawingModel.strokeType) {
  //     case StrokeType.eraser:
  //       return EraserStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //       );
  //     case StrokeType.line:
  //       return LineStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //       );
  //     case StrokeType.polygon:
  //       return PolygonStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //         sides: event.polygonSides ?? 3,
  //         filled: event.fillShape ?? false,
  //       );
  //     case StrokeType.circle:
  //       return CircleStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //         filled: event.fillShape ?? false,
  //       );
  //     case StrokeType.square:
  //       return SquareStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //         filled: event.fillShape ?? false,
  //       );
  //     default:
  //       return NormalStroke(
  //         points: event.drawingModel.points,
  //         color: event.drawingModel.color,
  //         size: event.drawingModel.size,
  //         opacity: event.drawingModel.opacity,
  //       );
  //   }
  // }

  // MARK: Private methods
  void _sendDraw(List<Stroke?> drawingModel) {
    // _waterbusSdk.sendDraw(meetingId: meetingId); // code not pushed yet
  }
  void _sendDeleteDraw(int meetingId) {
    // _waterbusSdk.deleteDraw(meetingId: meetingId); // code not pushed yet
  }
}
