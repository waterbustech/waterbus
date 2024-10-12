// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:waterbus/features/meeting/domain/models/drawing_canvas_options.dart';
// import 'package:waterbus/features/meeting/domain/models/drawing_tool.dart';
// import 'package:waterbus/features/meeting/domain/models/stroke.dart';
// import 'package:waterbus/features/meeting/domain/models/undo_redo_stack.dart';
// import 'package:waterbus/features/meeting/presentation/notifiers/current_stroke_value_notifier.dart';
// import 'package:waterbus/features/meeting/presentation/widgets/canvas_side_bar.dart';
// import 'package:waterbus/features/meeting/presentation/widgets/drawing_canvas.dart';
// import 'package:waterbus/features/meeting/presentation/widgets/hot_key_listener.dart';

// class DrawingPage extends StatefulWidget {
//   const DrawingPage({super.key});

//   @override
//   State<DrawingPage> createState() => _DrawingPageState();
// }

// class _DrawingPageState extends State<DrawingPage>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController animationController;

//   final ValueNotifier<Color> selectedColor = ValueNotifier(Colors.black);
//   final ValueNotifier<double> strokeSize = ValueNotifier(10.0);
//   final ValueNotifier<double> eraserSize = ValueNotifier(30.0);
//   final ValueNotifier<DrawingTool> drawingTool =
//       ValueNotifier(DrawingTool.pencil);
//   final GlobalKey canvasGlobalKey = GlobalKey();
//   final ValueNotifier<bool> filled = ValueNotifier(false);
//   final ValueNotifier<int> polygonSides = ValueNotifier(3);
//   final ValueNotifier<ui.Image?> backgroundImage = ValueNotifier(null);
//   final CurrentStrokeValueNotifier currentStroke = CurrentStrokeValueNotifier();
//   final ValueNotifier<List<Stroke>> allStrokes = ValueNotifier([]);
//   late final UndoRedoStack undoRedoStack;
//   final ValueNotifier<bool> showGrid = ValueNotifier(false);

//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     undoRedoStack = UndoRedoStack(
//       currentStrokeNotifier: currentStroke,
//       strokesNotifier: allStrokes,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f3f7),
//       body: HotkeyListener(
//         onRedo: undoRedoStack.redo,
//         onUndo: undoRedoStack.undo,
//         child: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: Listenable.merge([
//                 currentStroke,
//                 allStrokes,
//                 selectedColor,
//                 strokeSize,
//                 eraserSize,
//                 drawingTool,
//                 filled,
//                 polygonSides,
//                 backgroundImage,
//                 showGrid,
//               ]),
//               builder: (context, _) {
//                 return DrawingCanvas(
//                   options: DrawingCanvasOptions(
//                     currentTool: drawingTool.value,
//                     size: strokeSize.value,
//                     strokeColor: selectedColor.value,
//                     backgroundColor: const Color(0xfff2f3f7),
//                     polygonSides: polygonSides.value,
//                     showGrid: showGrid.value,
//                     fillShape: filled.value,
//                   ),
//                   canvasKey: canvasGlobalKey,
//                   currentStrokeListenable: currentStroke,
//                   strokesListenable: allStrokes,
//                   backgroundImageListenable: backgroundImage,
//                 );
//               },
//             ),
//             Positioned(
//               top: kToolbarHeight + 10,
//               child: SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(-1, 0),
//                   end: Offset.zero,
//                 ).animate(animationController),
//                 child: CanvasSideBar(
//                   drawingTool: drawingTool,
//                   selectedColor: selectedColor,
//                   strokeSize: strokeSize,
//                   eraserSize: eraserSize,
//                   currentSketch: currentStroke,
//                   allSketches: allStrokes,
//                   canvasGlobalKey: canvasGlobalKey,
//                   filled: filled,
//                   polygonSides: polygonSides,
//                   backgroundImage: backgroundImage,
//                   undoRedoStack: undoRedoStack,
//                   showGrid: showGrid,
//                 ),
//               ),
//             ),
//             _CustomAppBar(animationController: animationController),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CustomAppBar extends StatelessWidget {
//   final AnimationController animationController;

//   const _CustomAppBar({required this.animationController});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: kToolbarHeight,
//       width: double.maxFinite,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               onPressed: () {
//                 if (animationController.value == 0) {
//                   animationController.forward();
//                 } else {
//                   animationController.reverse();
//                 }
//               },
//               icon: const Icon(Icons.menu),
//             ),
//             const Text(
//               "Let's Draw",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 19,
//               ),
//             ),
//             const SizedBox.shrink(),
//           ],
//         ),
//       ),
//     );
//   }
// }
