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
  Color currentColor = Colors.black; // colors

  void onHanldeCancelDraw(points) {
    final DrawingModel drawingModel =
        DrawingModel(meetingId: widget.meetingId, points: points);
    AppBloc.drawingBloc.add(OnDrawingChangedEvent(drawingModel: drawingModel));
  }

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
    });
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
          body: Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: AbsorbPointer(
                    absorbing: drawingBlocked,
                    child: Listener(
                      onPointerMove: (details) {
                        myPoints = List.of(myPoints)
                          ..add(details.localPosition);
                        onHanldeCancelDraw(myPoints);
                      },
                      onPointerDown: (details) {
                        myPoints.add(null);
                      },
                      child: CustomPaint(
                        painter: DrawingPainter(drawing.props, currentColor),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColorPickerButton(Colors.black, changeColor),
                    ColorPickerButton(Colors.red, changeColor),
                    ColorPickerButton(Colors.blue, changeColor),
                    ColorPickerButton(Colors.green, changeColor),
                    ColorPickerButton(Colors.yellow, changeColor),
                    ColorPickerButton(Colors.purple, changeColor),
                    // Thêm các nút màu khác nếu cần
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              myPoints.clear();
              AppBloc.drawingBloc
                  .add(OnDrawingDeletedEvent(meetingId: widget.meetingId));
            },
            child: const Icon(Icons.clear),
          ),
        );
      },
    );
  }
}

class ColorPickerButton extends StatelessWidget {
  final Color color;
  final Function(Color) onColorSelected;

  const ColorPickerButton(this.color, this.onColorSelected, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onColorSelected(color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color; // Thêm thuộc tính màu sắc

  DrawingPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color // Sử dụng thuộc tính màu sắc
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
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
