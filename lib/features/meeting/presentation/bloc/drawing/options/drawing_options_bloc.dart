import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';

part 'drawing_options_event.dart';
part 'drawing_options_state.dart';

@injectable
class DrawingOptionsBloc
    extends Bloc<DrawingOptionsEvent, DrawingOptionsState> {
  DrawingOptionsBloc() : super(const DrawingOptionsInitial()) {
    on<DrawingOptionsEvent>((event, emit) {
      if (event is ChangeColorEvent) {
        emit(state.copyWith(selectedColor: event.color));
      }
      if (event is ChangeStrokeSizeEvent) {
        emit(state.copyWith(strokeSize: event.strokeSize));
      }
      if (event is ChangeDrawingToolEvent) {
        emit(state.copyWith(drawingTool: event.tool));
      }
      if (event is ChangeEraserSizeEvent) {
        emit(state.copyWith(eraserSize: event.eraserSize));
      }
      if (event is ChangePolygonSidesEvent) {
        emit(state.copyWith(polygonSides: event.sides));
      }
      if (event is ToggleGridEvent) {
        emit(state.copyWith(showGrid: !state.showGrid));
      }
      if (event is ToggleFilledEvent) {
        emit(state.copyWith(filled: !state.filled));
      }
    });
  }
}
