import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

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
  List<DrawingModel?> myPoints = [];
  var avaiableColor = [
    Colors.black,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.brown,
  ];
  var selectedColor = Colors.black;

  void onHandleEndDraw(points) {
    myPoints.add(null);
    AppBloc.drawingBloc.add(OnDrawingChangedEvent(drawingModel: myPoints));
  }

  void onHandleStartDraw(points) {
    final DrawingModel drawingModel = DrawingModel(
      meetingId: widget.meetingId,
      points: points,
      color: selectedColor,
    );
    setState(() {
      myPoints.add(drawingModel);
    });
    AppBloc.drawingBloc.add(OnDrawingChangedEvent(drawingModel: myPoints));
  }

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, drawing) {
        return Scaffold(
          body: Stack(
            children: [
              InteractiveViewer(
                child: AbsorbPointer(
                  absorbing: drawingBlocked,
                  child: Listener(
                    onPointerMove: (details) {
                      drawing.localProps.last =
                          drawing.localProps.last?.copyWith(
                        offsets: drawing.localProps.last!.points
                          ..add(details.localPosition),
                      );
                    },
                    onPointerDown: (details) {
                      onHandleStartDraw([details.localPosition]);
                    },
                    onPointerUp: (details) {
                      onHandleEndDraw([details.localPosition]);
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(myPoints),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 10.sp,
                right: 10.sp,
                child: SizedBox(
                  height: 30.sp,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: avaiableColor.length,
                    separatorBuilder: (_, __) {
                      return SizedBox(width: 15.sp);
                    },
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = avaiableColor[index];
                          });
                        },
                        child: Container(
                          width: 25.sp,
                          height: 25.sp,
                          decoration: BoxDecoration(
                            color: avaiableColor[index],
                            shape: BoxShape.circle,
                          ),
                          foregroundDecoration: BoxDecoration(
                            border: selectedColor == avaiableColor[index]
                                ? Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 0.5.h,
                                  )
                                : null,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                myPoints.clear();
              });
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
