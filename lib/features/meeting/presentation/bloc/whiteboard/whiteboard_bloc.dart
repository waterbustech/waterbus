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
  bool _isOpen = false;

  WhiteBoardBloc() : super(WhiteBoardInitialState()) {
    on<WhiteBoardEvent>((event, emit) {
      if (event is WhiteBoardUpdated) {
        _paints = event.draws;
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardStarted) {
        _handleDrawingInit(event);
      }

      if (event is WhiteBoardDrawed) {
        _waterbusSdk.updateWhiteBoard(
          event.drawModel,
          DrawActionEnum.updateAdd,
        );
      }

      if (event is WhiteBoardUndid) {
        _waterbusSdk.undo();
      }

      if (event is WhiteBoardRedid) {
        _waterbusSdk.redo();
      }

      if (event is WhiteBoardCleaned) {
        _waterbusSdk.cleanWhiteBoard();
      }

      if (event is WhiteBoardCleaned) {
        _waterbusSdk.cleanWhiteBoard();
      }

      // MARK: Options
      if (event is WhiteBoardColorChanged) {
        _currentPaint = _currentPaint.copyWith(color: event.color);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardStrokeSizeChanged) {
        _currentPaint = _currentPaint.copyWith(size: event.strokeSize);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardDrawShapesChanged) {
        _currentPaint = _currentPaint.copyWith(drawShapes: event.shapes);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardPolygonSidesChanged) {
        _currentPaint = _currentPaint.copyWith(polygonSides: event.sides);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardGridToggled) {
        _currentPaint = _currentPaint.copyWith(showGrid: event.showGrid);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardFilledToggled) {
        _currentPaint = _currentPaint.copyWith(isFilled: event.filled);
        emit(_whiteBoardDone);
      }

      if (event is WhiteBoardToggled) {
        _isOpen = !_isOpen;
        emit(_whiteBoardDone);
      }
    });
  }

  WhiteBoardDone get _whiteBoardDone => WhiteBoardDone(
        currentPaint: _currentPaint,
        paints: _paints,
        isOpen: _isOpen,
      );

  // MARK: Private methods
  void _handleDrawingInit(
    WhiteBoardStarted event,
  ) {
    _waterbusSdk.setOnDrawChanged = _callBackDrawChanged;
    _waterbusSdk.startWhiteBoard();
  }

  void _callBackDrawChanged(List<DrawModel> paints) {
    add(WhiteBoardUpdated(draws: paints));
  }
}
