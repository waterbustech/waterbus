// drawing_options_event.dart
part of 'drawing_options_bloc.dart';

abstract class DrawingOptionsEvent extends Equatable {
  const DrawingOptionsEvent();

  @override
  List<Object?> get props => [];
}

class ChangeColorEvent extends DrawingOptionsEvent {
  final Color color;

  const ChangeColorEvent(this.color);

  @override
  List<Object?> get props => [color];
}

class ChangeStrokeSizeEvent extends DrawingOptionsEvent {
  final double strokeSize;

  const ChangeStrokeSizeEvent(this.strokeSize);

  @override
  List<Object?> get props => [strokeSize];
}

class ChangeDrawingToolEvent extends DrawingOptionsEvent {
  final DrawingTool tool;

  const ChangeDrawingToolEvent(this.tool);

  @override
  List<Object?> get props => [tool];
}

class ToggleGridEvent extends DrawingOptionsEvent {
  final bool showGrid;
  const ToggleGridEvent(this.showGrid);

  @override
  List<Object?> get props => [showGrid];
}

class ToggleFilledEvent extends DrawingOptionsEvent {
  final bool filled;
  const ToggleFilledEvent(this.filled);

  @override
  List<Object?> get props => [filled];
}

class ChangePolygonSidesEvent extends DrawingOptionsEvent {
  final int sides;

  const ChangePolygonSidesEvent(this.sides);

  @override
  List<Object?> get props => [sides];
}
