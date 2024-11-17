part of 'whiteboard_bloc.dart';

sealed class WhiteBoardEvent {}

class WhiteBoardStarted extends WhiteBoardEvent {}

class WhiteBoardDraw extends WhiteBoardEvent {
  final DrawModel drawModel;
  WhiteBoardDraw({required this.drawModel});
}

class WhiteBoardUpdate extends WhiteBoardEvent {
  final List<DrawModel> draws;
  WhiteBoardUpdate({required this.draws});
}

class WhiteBoardClean extends WhiteBoardEvent {
  final int meetingId;
  WhiteBoardClean({required this.meetingId});
}

class WhiteBoardUndo extends WhiteBoardEvent {}

class OnRedoEvent extends WhiteBoardEvent {}

// MARK : side bar options
class WhiteBoardChangeColor extends WhiteBoardEvent {
  final Color color;

  WhiteBoardChangeColor(this.color);

  List<Object?> get props => [color];
}

class WhiteBoardChangeStrokeSize extends WhiteBoardEvent {
  final double strokeSize;

  WhiteBoardChangeStrokeSize(this.strokeSize);

  List<Object?> get props => [strokeSize];
}

class WhiteBoardChangeDrawShapes extends WhiteBoardEvent {
  final DrawShapes shapes;

  WhiteBoardChangeDrawShapes(this.shapes);

  List<Object?> get props => [shapes];
}

class WhiteBoardToggleGrid extends WhiteBoardEvent {
  final bool showGrid;
  WhiteBoardToggleGrid(this.showGrid);

  List<Object?> get props => [showGrid];
}

class WhiteBoardToggleFilled extends WhiteBoardEvent {
  final bool filled;
  WhiteBoardToggleFilled(this.filled);

  List<Object?> get props => [filled];
}

class WhiteBoardChangePolygonSides extends WhiteBoardEvent {
  final int sides;

  WhiteBoardChangePolygonSides(this.sides);

  List<Object?> get props => [sides];
}
