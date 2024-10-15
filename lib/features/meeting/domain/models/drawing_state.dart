import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/models/draw_model.dart';

import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';

class DrawingState {
  final Color selectedColor;
  final double strokeSize;
  final DrawingTool drawingTool;
  final bool filled;
  final int polygonSides;
  final ui.Image? backgroundImage;
  final List<DrawModel> allStrokes;
  final bool showGrid;

  DrawingState({
    required this.selectedColor,
    required this.strokeSize,
    required this.drawingTool,
    required this.filled,
    required this.polygonSides,
    this.backgroundImage,
    required this.allStrokes,
    required this.showGrid,
  });

  DrawingState copyWith({
    Color? selectedColor,
    double? strokeSize,
    DrawingTool? drawingTool,
    bool? filled,
    int? polygonSides,
    ui.Image? backgroundImage,
    List<DrawModel>? allStrokes,
    bool? showGrid,
  }) {
    return DrawingState(
      selectedColor: selectedColor ?? this.selectedColor,
      strokeSize: strokeSize ?? this.strokeSize,
      drawingTool: drawingTool ?? this.drawingTool,
      filled: filled ?? this.filled,
      polygonSides: polygonSides ?? this.polygonSides,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      allStrokes: allStrokes ?? this.allStrokes,
      showGrid: showGrid ?? this.showGrid,
    );
  }
}
