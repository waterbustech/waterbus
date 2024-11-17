import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/draw_action.dart';
import 'package:waterbus_sdk/types/enums/draw_shapes.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

part 'whiteboard_event.dart';
part 'whiteboard_state.dart';

@injectable
class WhiteBoardBloc extends Bloc<WhiteBoardEvent, WhiteBoardState> {
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  List<DrawModel> _paints = [];
  DrawModel _currentPaint = DrawModel(points: const []);

  WhiteBoardBloc() : super(WhiteBoardInitialState()) {
    on<WhiteBoardEvent>((event, emit) {
      if (event is WhiteBoardUpdate) {
        _paints = event.draws;
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardStarted) {
        _handleDrawingInit(event);
      }

      if (event is WhiteBoardDraw) {
        _waterbusSdk.updateWhiteBoard(
          event.drawModel,
          DrawActionEnum.updateAdd,
        );
      }

      if (event is WhiteBoardUndo) {
        _waterbusSdk.undo();
      }

      if (event is OnRedoEvent) {
        _waterbusSdk.redo();
      }

      if (event is WhiteBoardClean) {
        _waterbusSdk.cleanWhiteBoard();
      }

      // MARK: Options
      if (event is WhiteBoardChangeColor) {
        _currentPaint = _currentPaint.copyWith(color: event.color);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardChangeStrokeSize) {
        _currentPaint = _currentPaint.copyWith(size: event.strokeSize);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardChangeDrawShapes) {
        _currentPaint = _currentPaint.copyWith(drawShapes: event.shapes);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardChangePolygonSides) {
        _currentPaint = _currentPaint.copyWith(polygonSides: event.sides);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardToggleGrid) {
        _currentPaint = _currentPaint.copyWith(showGrid: event.showGrid);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardToggleFilled) {
        _currentPaint = _currentPaint.copyWith(isFilled: event.filled);
        emit(_whiteBoardDone);
      }
    });
  }

  WhiteBoardDone get _whiteBoardDone => WhiteBoardDone(
        currentPaint: _currentPaint,
        paints: _paints,
      );

  // MARK: Private methods
  void _handleDrawingInit(
    WhiteBoardStarted event,
  ) {
    _waterbusSdk.setOnDrawChanged = _callBackDrawChanged;
    _waterbusSdk.startWhiteBoard();
  }

  void _callBackDrawChanged(List<DrawModel> paints) {
    add(WhiteBoardUpdate(draws: paints));
  }
}
