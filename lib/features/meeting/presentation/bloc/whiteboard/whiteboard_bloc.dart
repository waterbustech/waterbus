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
      if (event is OnUpdateBoardEvent) {
        _paints = event.draws;
        emit(_getDoneWhiteBoard);
      }

      if (event is OnStartWhiteBoardEvent) {
        _handleDrawingInit(event);
      }

      if (event is OnDrawEvent) {
        _waterbusSdk.updateWhiteBoard(
          event.drawModel,
          DrawActionEnum.updateAdd,
        );
      }

      if (event is OnUndoEvent) {
        _waterbusSdk.undo();
      }

      if (event is OnRedoEvent) {
        _waterbusSdk.redo();
      }

      if (event is CleanWhiteBoardEvent) {
        _waterbusSdk.cleanWhiteBoard();
      }

      // MARK: Options
      if (event is ChangeColorEvent) {
        _currentPaint = _currentPaint.copyWith(color: event.color);
        emit(_getDoneWhiteBoard);
      }

      if (event is ChangeStrokeSizeEvent) {
        _currentPaint = _currentPaint.copyWith(size: event.strokeSize);
        emit(_getDoneWhiteBoard);
      }

      if (event is ChangeDrawShapesEvent) {
        _currentPaint = _currentPaint.copyWith(drawShapes: event.shapes);
        emit(_getDoneWhiteBoard);
      }

      if (event is ChangePolygonSidesEvent) {
        _currentPaint = _currentPaint.copyWith(polygonSides: event.sides);
        emit(_getDoneWhiteBoard);
      }

      if (event is ToggleGridEvent) {
        _currentPaint = _currentPaint.copyWith(showGrid: event.showGrid);
        emit(_getDoneWhiteBoard);
      }

      if (event is ToggleFilledEvent) {
        _currentPaint = _currentPaint.copyWith(isFilled: event.filled);
        emit(_getDoneWhiteBoard);
      }
    });
  }

  GetDoneWhiteBoard get _getDoneWhiteBoard => GetDoneWhiteBoard(
        currentPaint: _currentPaint,
        paints: _paints,
      );

  // MARK: Private methods
  void _handleDrawingInit(
    OnStartWhiteBoardEvent event,
  ) {
    _waterbusSdk.setOnDrawChanged = _callBackDrawChanged;
    _waterbusSdk.startWhiteBoard();
  }

  void _callBackDrawChanged(List<DrawModel> paints) {
    add(OnUpdateBoardEvent(draws: paints));
  }
}
