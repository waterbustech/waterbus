import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/enums/draw_types.dart';

import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';

extension DrawingToolExtensions on DrawingTool {
  DrawTypes get strokeType {
    switch (this) {
      case DrawingTool.pencil:
        return DrawTypes.normal;
      case DrawingTool.fill:
        return DrawTypes.normal;
      case DrawingTool.eraser:
        return DrawTypes.eraser;
      case DrawingTool.line:
        return DrawTypes.line;
      case DrawingTool.polygon:
        return DrawTypes.polygon;
      case DrawingTool.square:
        return DrawTypes.square;
      case DrawingTool.circle:
        return DrawTypes.circle;
    }
  }

  MouseCursor get cursor {
    switch (this) {
      case DrawingTool.pencil:
      case DrawingTool.line:
      case DrawingTool.polygon:
      case DrawingTool.square:
      case DrawingTool.circle:
      case DrawingTool.eraser:
        return SystemMouseCursors.precise;
      case DrawingTool.fill:
        return SystemMouseCursors.click;
    }
  }
}
