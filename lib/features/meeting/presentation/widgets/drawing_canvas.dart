import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus_sdk/types/extensions/drawing_tool_extensions.dart';
import 'package:waterbus_sdk/types/models/current_stroke_value.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

import 'package:waterbus/core/types/extensions/offset_extensions.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/whiteboard/whiteboard_bloc.dart';

class DrawingCanvas extends StatefulWidget {
  final DrawModel options;
  final GlobalKey canvasKey;
  final ui.Image? backgroundImage;
  final CurrentStroke? currentDraw;

  const DrawingCanvas({
    super.key,
    required this.options,
    required this.canvasKey,
    this.backgroundImage,
    this.currentDraw,
  });

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  CurrentStroke get _currentStroke => widget.currentDraw!;

  void _onPointerDown(PointerDownEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.globalToLocal(event.position);
    final standardOffset = offset.scaleToStandard(box.size);
    _currentStroke.startStroke(
      standardOffset,
      color: widget.options.color,
      size: widget.options.size,
      type: widget.options.drawShapes.strokeType,
      sides: widget.options.polygonSides,
      filled: widget.options.isFilled,
    );
  }

  void _onPointerMove(PointerMoveEvent event) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.globalToLocal(event.position);
    final standardOffset = offset.scaleToStandard(box.size);
    setState(() {
      _currentStroke.addPoint(standardOffset);
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_currentStroke.hasStroke) return;

    final newDraw = _currentStroke.value!.copyWith();
    AppBloc.whiteBoardBloc.add(
      OnDrawEvent(drawModel: newDraw),
    );
    _currentStroke.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhiteBoardBloc, WhiteBoardState>(
      builder: (context, state) {
        return BlocBuilder<WhiteBoardBloc, WhiteBoardState>(
          builder: (context, stateOptions) {
            return MouseRegion(
              cursor: widget.options.drawShapes.cursor,
              child: Listener(
                onPointerUp: _onPointerUp,
                onPointerMove: _onPointerMove,
                onPointerDown: _onPointerDown,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RepaintBoundary(
                        key: widget.canvasKey,
                        child: CustomPaint(
                          isComplex: true,
                          painter: _DrawingCanvasPainter(
                            strokesListenable: state.paints,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          isComplex: true,
                          painter: _DrawingCanvasPainter(
                            strokeListenable: _currentStroke,
                            showGrid: state.currentDraw!.showGrid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _DrawingCanvasPainter extends CustomPainter {
  final List<DrawModel?>? strokesListenable;
  final CurrentStroke? strokeListenable;
  final bool? showGrid;

  _DrawingCanvasPainter({
    this.strokesListenable,
    this.strokeListenable,
    this.showGrid,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final strokes = List<DrawModel>.from(strokesListenable ?? []);
    if (strokeListenable?.hasStroke ?? false) {
      strokes.add(strokeListenable!.value!);
    }
    for (final stroke in strokes) {
      final points = stroke.points;
      if (points.isEmpty) continue;

      final strokeSize = max(stroke.size, 1.0);
      final paint = Paint()
        ..color = stroke.color.withOpacity(1.00)
        ..strokeWidth = strokeSize
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // Pencil stroke
      if (stroke is NormalStroke) {
        final path = _getStrokePath(stroke, size);

        // If the path only has one line, draw a dot.
        if (stroke.points.length == 1) {
          // scale the point to the standard size
          final center = stroke.points.first.scaleFromStandard(size);
          final radius = strokeSize / 2;
          canvas.drawCircle(center, radius, paint..style = PaintingStyle.fill);

          continue;
        }

        canvas.drawPath(path, paint);
        continue;
      }

      if (stroke is EraserStroke) {
        final path = _getStrokePath(stroke, size);
        canvas.drawPath(path, paint..color = Colors.white);
        continue;
      }

      // Line stroke.
      if (stroke is LineStroke) {
        final firstPoint = points.first.scaleFromStandard(size);
        final lastPoint = points.last.scaleFromStandard(size);
        canvas.drawLine(firstPoint, lastPoint, paint);
        continue;
      }

      if (stroke is CircleStroke) {
        // scale the points to the standard size
        final firstPoint = points.first.scaleFromStandard(size);
        final lastPoint = points.last.scaleFromStandard(size);
        final rect = Rect.fromPoints(firstPoint, lastPoint);

        if (stroke.filled) {
          paint.style = PaintingStyle.fill;
        }

        canvas.drawOval(rect, paint);
        continue;
      }

      if (stroke is SquareStroke) {
        // scale the points to the standard size
        final firstPoint = points.first.scaleFromStandard(size);
        final lastPoint = points.last.scaleFromStandard(size);
        final rect = Rect.fromPoints(firstPoint, lastPoint);

        if (stroke.filled) {
          paint.style = PaintingStyle.fill;
        }

        canvas.drawRect(rect, paint);
        continue;
      }

      if (stroke is PolygonStroke) {
        // scale the points to the standard size
        final firstPoint = points.first.scaleFromStandard(size);
        final lastPoint = points.last.scaleFromStandard(size);
        final centerPoint = (firstPoint / 2) + (lastPoint / 2);
        final radius = (firstPoint - lastPoint).distance / 2;
        final sides = stroke.sides;
        final angle = (2 * pi) / sides;
        final path = Path();
        final double x = centerPoint.dx;
        final double y = centerPoint.dy;
        final double radiusX = radius;
        final double radiusY = radius;
        const double initialAngle = -pi / 2;
        final double centerX = x + radiusX * cos(initialAngle);
        final double centerY = y + radiusY * sin(initialAngle);
        path.moveTo(centerX, centerY);
        for (int i = 1; i <= sides; i++) {
          final double currentAngle = initialAngle + (angle * i);
          final double x = centerPoint.dx + radius * cos(currentAngle);
          final double y = centerPoint.dy + radius * sin(currentAngle);
          path.lineTo(x, y);
        }
        path.close();

        if (stroke.filled) {
          paint.style = PaintingStyle.fill;
        }
        canvas.drawPath(path, paint);
        continue;
      }
    }

    // Draw the grid last so it's on top of everything else.
    if (showGrid ?? false) {
      _drawGrid(size, canvas);
    }
  }

  void _drawGrid(Size size, Canvas canvas) {
    const gridStrokeWidth = 1.0;
    const gridSpacing = 50.0;
    const subGridSpacing = 10.0; // Spacing for smaller boxes
    const subGridStrokeWidth = 0.5; // Lighter stroke for smaller boxes

    final gridPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = gridStrokeWidth;

    final subGridPaint = Paint()
      ..color = Colors.grey // Lighter color for the smaller grid
      ..strokeWidth = subGridStrokeWidth;

    // Horizontal lines for main grid
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Vertical lines for main grid
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw smaller boxes within each grid cell
    for (double y = 0; y <= size.height; y += gridSpacing) {
      for (double subY = y;
          subY < y + gridSpacing && subY <= size.height;
          subY += subGridSpacing) {
        canvas.drawLine(
          Offset(0, subY),
          Offset(size.width, subY),
          subGridPaint,
        );
      }
    }

    for (double x = 0; x <= size.width; x += gridSpacing) {
      for (double subX = x;
          subX < x + gridSpacing && subX <= size.width;
          subX += subGridSpacing) {
        canvas.drawLine(
          Offset(subX, 0),
          Offset(subX, size.height),
          subGridPaint,
        );
      }
    }
  }

  Path _getStrokePath(DrawModel stroke, Size size) {
    final path = Path();
    final points = stroke.points;
    if (points.isNotEmpty) {
      // scale the point to the standard size
      final firstPoint = points.first.scaleFromStandard(size);
      path.moveTo(firstPoint.dx, firstPoint.dy);
      for (int i = 1; i < points.length - 1; ++i) {
        // scale the points to the standard size
        final p0 = points[i].scaleFromStandard(size);
        final p1 = points[i + 1].scaleFromStandard(size);

        // use quadratic bezier to draw smooth curves through the points
        path.quadraticBezierTo(
          p0.dx,
          p0.dy,
          (p0.dx + p1.dx) / 2,
          (p0.dy + p1.dy) / 2,
        );
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
