import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_event.dart';
import 'package:waterbus/features/meeting/presentation/socket/drawing/socket_draw_handle.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  DrawingScreenState createState() => DrawingScreenState();
}

class DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  bool drawingBlocked = false;

  void onHanldeCancelDraw() {
    AppBloc.drawingBloc.add(OnDrawingChangedEvent(points: points));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DrawingBloc, DrawingState>(
        builder: (context, drawing) {
          final otherPainters = drawing.props as List<Offset?>;
          points.addAll(otherPainters);
          return InteractiveViewer(
            child: AbsorbPointer(
              absorbing: drawingBlocked,
              child: Listener(
                onPointerMove: (details) {
                  setState(() {
                    points = List.of(points)..add(details.localPosition);
                  });
                },
                onPointerCancel: (event) => onHanldeCancelDraw,
                onPointerDown: (details) {
                  setState(() {
                    points.add(null);
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(points),
                  size: Size.infinite,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            points.clear(); // Clear the screen
          });
        },
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!], paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
