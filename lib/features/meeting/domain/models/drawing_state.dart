import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';
import 'package:waterbus/features/meeting/domain/models/stroke.dart';

class DrawingState {
  final Color selectedColor;
  final double strokeSize;
  final double eraserSize;
  final DrawingTool drawingTool;
  final bool filled;
  final int polygonSides;
  final ui.Image? backgroundImage;
  final List<Stroke> allStrokes;
  final bool showGrid;

  DrawingState({
    required this.selectedColor,
    required this.strokeSize,
    required this.eraserSize,
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
    double? eraserSize,
    DrawingTool? drawingTool,
    bool? filled,
    int? polygonSides,
    ui.Image? backgroundImage,
    List<Stroke>? allStrokes,
    bool? showGrid,
  }) {
    return DrawingState(
      selectedColor: selectedColor ?? this.selectedColor,
      strokeSize: strokeSize ?? this.strokeSize,
      eraserSize: eraserSize ?? this.eraserSize,
      drawingTool: drawingTool ?? this.drawingTool,
      filled: filled ?? this.filled,
      polygonSides: polygonSides ?? this.polygonSides,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      allStrokes: allStrokes ?? this.allStrokes,
      showGrid: showGrid ?? this.showGrid,
    );
  }
}
