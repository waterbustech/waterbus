// drawing_options_state.dart
part of 'drawing_options_bloc.dart';

class DrawingOptionsState extends Equatable {
  final Color selectedColor;
  final double strokeSize;
  final double eraserSize;
  final DrawingTool drawingTool;
  final bool showGrid;
  final int polygonSides;
  final bool filled;

  const DrawingOptionsState({
    required this.selectedColor,
    required this.strokeSize,
    required this.eraserSize,
    required this.drawingTool,
    required this.showGrid,
    required this.polygonSides,
    required this.filled,
  });

  DrawingOptionsState copyWith({
    Color? selectedColor,
    double? strokeSize,
    double? eraserSize,
    DrawingTool? drawingTool,
    bool? showGrid,
    int? polygonSides,
    bool? filled,
  }) {
    return DrawingOptionsState(
      selectedColor: selectedColor ?? this.selectedColor,
      strokeSize: strokeSize ?? this.strokeSize,
      eraserSize: eraserSize ?? this.eraserSize,
      drawingTool: drawingTool ?? this.drawingTool,
      showGrid: showGrid ?? this.showGrid,
      polygonSides: polygonSides ?? this.polygonSides,
      filled: filled ?? this.filled,
    );
  }

  @override
  List<Object?> get props => [
        selectedColor,
        strokeSize,
        eraserSize,
        drawingTool,
        showGrid,
        polygonSides,
        filled,
      ];
}

class DrawingOptionsInitial extends DrawingOptionsState {
  const DrawingOptionsInitial()
      : super(
          selectedColor: Colors.black,
          strokeSize: 10.0,
          eraserSize: 30.0,
          drawingTool: DrawingTool.pencil,
          showGrid: false,
          polygonSides: 3,
          filled: false,
        );
}
