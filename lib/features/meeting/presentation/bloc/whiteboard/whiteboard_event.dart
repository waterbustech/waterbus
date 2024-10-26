part of 'whiteboard_bloc.dart';

sealed class WhiteBoardEvent {}

class OnStartWhiteBoardEvent extends WhiteBoardEvent {}

class OnDrawEvent extends WhiteBoardEvent {
  final DrawModel drawModel;
  OnDrawEvent({required this.drawModel});
}

class OnUpdateBoardEvent extends WhiteBoardEvent {
  final List<DrawModel> draws;
  OnUpdateBoardEvent({required this.draws});
}

class CleanWhiteBoardEvent extends WhiteBoardEvent {
  final int meetingId;
  CleanWhiteBoardEvent({required this.meetingId});
}

class OnUndoEvent extends WhiteBoardEvent {}

class OnRedoEvent extends WhiteBoardEvent {}

// MARK : side bar options
class ChangeColorEvent extends WhiteBoardEvent {
  final Color color;

  ChangeColorEvent(this.color);

  List<Object?> get props => [color];
}

class ChangeStrokeSizeEvent extends WhiteBoardEvent {
  final double strokeSize;

  ChangeStrokeSizeEvent(this.strokeSize);

  List<Object?> get props => [strokeSize];
}

class ChangeDrawShapesEvent extends WhiteBoardEvent {
  final DrawShapes shapes;

  ChangeDrawShapesEvent(this.shapes);

  List<Object?> get props => [shapes];
}

class ToggleGridEvent extends WhiteBoardEvent {
  final bool showGrid;
  ToggleGridEvent(this.showGrid);

  List<Object?> get props => [showGrid];
}

class ToggleFilledEvent extends WhiteBoardEvent {
  final bool filled;
  ToggleFilledEvent(this.filled);

  List<Object?> get props => [filled];
}

class ChangePolygonSidesEvent extends WhiteBoardEvent {
  final int sides;

  ChangePolygonSidesEvent(this.sides);

  List<Object?> get props => [sides];
}
