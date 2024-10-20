import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/current_stroke_value.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/whiteboard/whiteboard_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/canvas_side_bar.dart';
import 'package:waterbus/features/meeting/presentation/widgets/drawing_canvas.dart';

class WhiteBoardWidget extends StatefulWidget {
  const WhiteBoardWidget({super.key});

  @override
  WhiteBoardWidgetState createState() => WhiteBoardWidgetState();
}

class WhiteBoardWidgetState extends State<WhiteBoardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  final GlobalKey canvasGlobalKey = GlobalKey();
  ui.Image? backgroundImage;
  List<DrawModel?> historyDraw = [];
  late final CurrentStroke _currentDraw;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );
    _currentDraw = CurrentStroke();
    AppBloc.whiteBoardBloc.add(OnStartWhiteBoardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mCL,
      body: Stack(
        children: [
          BlocBuilder<WhiteBoardBloc, WhiteBoardState>(
            builder: (context, state) {
              return DrawingCanvas(
                currentPaint: state.currentPaint,
                currentStroke: _currentDraw,
                canvasKey: canvasGlobalKey,
                backgroundImage: backgroundImage,
              );
            },
          ),
          Positioned(
            top: kToolbarHeight - 15,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -2),
                end: Offset.zero,
              ).animate(animationController),
              child: SizedBox(
                width: 100.w,
                child: CanvasSideBar(
                  canvasGlobalKey: canvasGlobalKey,
                  historyDraw: historyDraw,
                ),
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
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return IconButton(
                  onPressed: () {
                    if (animationController.value == 0) {
                      animationController.forward();
                    } else {
                      animationController.reverse();
                    }
                  },
                  icon: Icon(
                    animationController.value == 0
                        ? PhosphorIcons.caretDown()
                        : PhosphorIcons.caretUp(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
