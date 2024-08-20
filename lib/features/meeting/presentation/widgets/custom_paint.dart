import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/xmodels/drawing_model.dart';

class DrawingScreen extends StatefulWidget {
  final int meetingId;
  const DrawingScreen({super.key, required this.meetingId});

  @override
  DrawingScreenState createState() => DrawingScreenState();
}

class DrawingScreenState extends State<DrawingScreen> {
  bool drawingBlocked = false;

  void onHanldeCancelDraw(points) {
    final DrawingModel drawingModel =
        DrawingModel(meetingId: widget.meetingId, points: points);
    AppBloc.drawingBloc.add(OnDrawingChangedEvent(drawingModel: drawingModel));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, drawing) {
        var myPoints = drawing.myProps;
        return Scaffold(
          body: InteractiveViewer(
            child: AbsorbPointer(
              absorbing: drawingBlocked,
              child: Listener(
                onPointerMove: (details) {
                  myPoints = List.of(myPoints)..add(details.localPosition);
                },
                onPointerCancel: (event) => onHanldeCancelDraw(myPoints),
                onPointerDown: (details) {
                  setState(() {
                    myPoints.add(null);
                  });
                },
                child: CustomPaint(
                  painter: DrawingPainter(drawing.props),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                myPoints.clear();
                AppBloc.drawingBloc
                    .add(OnDrawingDeletedEvent(meetingId: widget.meetingId));
              });
            },
            child: const Icon(Icons.clear),
          ),
        );
      },
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
