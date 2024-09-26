import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/constants.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/colors_picker_item.dart';
import 'package:waterbus/features/meeting/presentation/widgets/drawing_painter.dart';
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
  List<DrawingModel?> historyDrawingPoints = [];
  DrawingModel? currentDrawingPoint;
  bool isDelete = false;
  var _selectedColor = availableColor[0];
  bool isEraserActive = false;

  void onHandleEndDraw() {
    currentDrawingPoint = null;
  }

  void onHandleStartDraw(points) {
    currentDrawingPoint = DrawingModel(
      participantId: widget.meetingId,
      points: points,
      color: isEraserActive ? mCL : _selectedColor,
    );

    if (currentDrawingPoint == null) return;

    setState(() {
      myPoints.add(currentDrawingPoint);
      historyDrawingPoints = List.of(myPoints);
    });

    AppBloc.drawingBloc.add(OnDrawingChangedEvent(drawingModel: myPoints));
  }

  void onChangeColors(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, drawing) {
        return Scaffold(
          backgroundColor: mCL,
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
                      onHandleEndDraw();
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(myPoints),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
              ColorsPickerItem(
                onChangeColors: onChangeColors,
                onSelectedColor: _selectedColor,
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: myPoints.isNotEmpty,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isEraserActive = !isEraserActive;
                    });
                  },
                  child:
                      Icon(isEraserActive ? Icons.brush : Icons.remove_circle),
                ),
              ),
              const SizedBox(width: 16),
              Visibility(
                visible: myPoints.isNotEmpty || isDelete == true,
                child: FloatingActionButton(
                  onPressed: () {
                    if (isDelete) {
                      setState(() {
                        isDelete = false;
                        isEraserActive = !isEraserActive;
                        myPoints.addAll(historyDrawingPoints);
                      });
                    } else {
                      setState(() {
                        isEraserActive = !isEraserActive;
                        if (myPoints.isNotEmpty) myPoints.removeLast();
                      });
                    }
                  },
                  child: const Icon(Icons.undo),
                ),
              ),
              const SizedBox(width: 16),
              Visibility(
                visible: myPoints.length < historyDrawingPoints.length &&
                    myPoints.isNotEmpty,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isEraserActive = !isEraserActive;
                      myPoints.add(historyDrawingPoints[myPoints.length]);
                    });
                  },
                  child: const Icon(Icons.redo),
                ),
              ),
              const SizedBox(width: 16),
              Visibility(
                visible: myPoints.isNotEmpty,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      myPoints.clear();
                      isDelete = true;
                    });
                    AppBloc.drawingBloc.add(
                      OnDrawingDeletedEvent(meetingId: widget.meetingId),
                    );
                  },
                  child: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
