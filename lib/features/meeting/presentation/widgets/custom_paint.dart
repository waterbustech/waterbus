import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/meeting/domain/models/drawing_canvas_options.dart';
import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';
import 'package:waterbus/features/meeting/domain/models/undo_redo_stack.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/handle_socket/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/options/drawing_options_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/canvas_side_bar.dart';
import 'package:waterbus/features/meeting/presentation/widgets/drawing_canvas.dart';

class DrawingScreen extends StatefulWidget {
  final int meetingId;

  const DrawingScreen({super.key, required this.meetingId});

  @override
  DrawingScreenState createState() => DrawingScreenState();
}

class DrawingScreenState extends State<DrawingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  Color selectedColor = Colors.black;
  double strokeSize = 10.0;
  double eraserSize = 30.0;
  DrawingTool drawingTool = DrawingTool.pencil;
  final GlobalKey canvasGlobalKey = GlobalKey();
  bool filled = false;
  int polygonSides = 3;
  ui.Image? backgroundImage;
  // late final UndoRedoStack undoRedoStack;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  // final props = context.read<DrawingBloc>().state.props;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mCL,
      body: Stack(
        children: [
          BlocBuilder<DrawingOptionsBloc, DrawingOptionsState>(
            builder: (context, state) {
              // Sử dụng BLoC để xây dựng canvas
              return DrawingCanvas(
                options: DrawingCanvasOptions(
                  currentTool: state.drawingTool,
                  size: state.strokeSize,
                  strokeColor: state.selectedColor,
                  backgroundColor: const Color(0xfff2f3f7),
                  polygonSides: state.polygonSides,
                  fillShape: state.filled, // not bloc
                ),
                canvasKey: canvasGlobalKey,
                backgroundImage: backgroundImage,
              );
            },
          ),
          Positioned(
            top: kToolbarHeight - 15,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).animate(animationController),
              child: CanvasSideBar(
                canvasGlobalKey: canvasGlobalKey,
                // undoRedoStack: undoRedoStack,
              ),
            ),
          ),
          _CustomAppBar(animationController: animationController),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({required this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.menu),
            ),
            const Text(
              "Let's Draw",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
