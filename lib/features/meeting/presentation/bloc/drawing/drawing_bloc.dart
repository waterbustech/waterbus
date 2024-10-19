import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_shapes.dart';
import 'package:waterbus_sdk/types/enums/draw_socket_enum.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';

part 'drawing_event.dart';
part 'drawing_state.dart';

@injectable
class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  DrawingBloc() : super(DrawingInitialState()) {
    on<DrawingEvent>((event, emit) {
      // MARK: List draw
      if (event is OnDrawingInitEvent) {
        _handleDrawingInit(event);
      } else if (event is OnNewDrawEvent) {
        _waterbusSdk.updateWhiteBoard(
          event.drawList,
          DrawActionEnum.updateAdd,
        );
      } else if (event is OnUpdateDrawEvent) {
        _handleDrawingChanged(
          event.drawList,
          emit,
        );
      } else if (event is OnUndoEvent) {
        _waterbusSdk.undo();
      } else if (event is OnRedoEvent) {
        _waterbusSdk.redo();
      } else if (event is OnDrawingDeletedEvent) {
        _waterbusSdk.cleanWhiteBoard();
      } // MARK: Options
      if (event is ChangeColorEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(color: event.color),
          ),
        );
      }
      if (event is ChangeStrokeSizeEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(size: event.strokeSize),
          ),
        );
      }
      if (event is ChangeDrawShapesEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(drawShapes: event.shapes),
          ),
        );
      }
      if (event is ChangePolygonSidesEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(polygonSides: event.sides),
          ),
        );
      }
      if (event is ToggleGridEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(showGrid: event.showGrid),
          ),
        );
      }
      if (event is ToggleFilledEvent) {
        emit(
          state.copyWith(
            currentDraw: state.currentDraw!.copyWith(isFilled: event.filled),
          ),
        );
      }
    });
  }

  // MARK: Private methods
  void _handleDrawingInit(
    OnDrawingInitEvent event,
  ) {
    _waterbusSdk.setOnDrawChanged = _callBackDrawChanged;
    _waterbusSdk.startWhiteBoard();
  }

  void _callBackDrawChanged(
    List<DrawModel> drawList,
  ) {
    AppBloc.drawingBloc.add(OnUpdateDrawEvent(drawList: drawList));
  }

  void _handleDrawingChanged(
    List<DrawModel> drawingModel,
    Emitter<DrawingState> emit,
  ) {
    emit(state.copyWith(drawList: drawingModel));
  }
}
