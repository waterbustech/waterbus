part of 'whiteboard_bloc.dart';

sealed class WhiteBoardEvent {}

class WhiteBoardStarted extends WhiteBoardEvent {}

class WhiteBoardDrawed extends WhiteBoardEvent {
  final DrawModel drawModel;
  WhiteBoardDrawed({required this.drawModel});
}

class WhiteBoardUpdated extends WhiteBoardEvent {
  final List<DrawModel> draws;
  WhiteBoardUpdated({required this.draws});
}

class WhiteBoardCleaned extends WhiteBoardEvent {
  final int meetingId;
  WhiteBoardCleaned({required this.meetingId});
}

class WhiteBoardUndid extends WhiteBoardEvent {}

class WhiteBoardRedid extends WhiteBoardEvent {}

// MARK : side bar options
class WhiteBoardColorChanged extends WhiteBoardEvent {
  final Color color;

  WhiteBoardColorChanged(this.color);

  List<Object?> get props => [color];
}

class WhiteBoardStrokeSizeChanged extends WhiteBoardEvent {
  final double strokeSize;

  WhiteBoardStrokeSizeChanged(this.strokeSize);

  List<Object?> get props => [strokeSize];
}

class WhiteBoardDrawShapesChanged extends WhiteBoardEvent {
  final DrawShapes shapes;

  WhiteBoardDrawShapesChanged(this.shapes);

  List<Object?> get props => [shapes];
}

class WhiteBoardGridToggled extends WhiteBoardEvent {
  final bool showGrid;
  WhiteBoardGridToggled(this.showGrid);

  List<Object?> get props => [showGrid];
}

class WhiteBoardFilledToggled extends WhiteBoardEvent {
  final bool filled;
  WhiteBoardFilledToggled(this.filled);

  List<Object?> get props => [filled];
}

class WhiteBoardPolygonSidesChanged extends WhiteBoardEvent {
  final int sides;

  WhiteBoardPolygonSidesChanged(this.sides);

  List<Object?> get props => [sides];
}
