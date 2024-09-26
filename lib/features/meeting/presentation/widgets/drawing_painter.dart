import 'package:flutter/material.dart';

import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingModel?> drawingModels;

  DrawingPainter(this.drawingModels);

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawingModel in drawingModels) {
      if (drawingModel != null) {
        final paint = Paint()
          ..color = drawingModel.color
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;

        for (int i = 0; i < drawingModel.points.length - 1; i++) {
          canvas.drawLine(
            drawingModel.points[i],
            drawingModel.points[i + 1],
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return true;
  }
}
