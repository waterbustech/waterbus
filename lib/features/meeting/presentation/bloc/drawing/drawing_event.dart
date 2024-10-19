part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingInitEvent extends DrawingEvent {}

class OnNewDrawEvent extends DrawingEvent {
  final DrawModel drawList;
  OnNewDrawEvent({
    required this.drawList,
  });
}

class OnUpdateDrawEvent extends DrawingEvent {
  final List<DrawModel> drawList;
  OnUpdateDrawEvent({
    required this.drawList,
  });
}

class OnDrawingDeletedEvent extends DrawingEvent {
  final int meetingId;
  OnDrawingDeletedEvent({required this.meetingId});
}

class OnUndoEvent extends DrawingEvent {}

class OnRedoEvent extends DrawingEvent {}

// MARK : side bar options

class ChangeColorEvent extends DrawingEvent {
  final Color color;

  ChangeColorEvent(this.color);

  List<Object?> get props => [color];
}

class ChangeStrokeSizeEvent extends DrawingEvent {
  final double strokeSize;

  ChangeStrokeSizeEvent(this.strokeSize);

  List<Object?> get props => [strokeSize];
}

class ChangeDrawShapesEvent extends DrawingEvent {
  final DrawShapes shapes;

  ChangeDrawShapesEvent(this.shapes);

  List<Object?> get props => [shapes];
}

class ToggleGridEvent extends DrawingEvent {
  final bool showGrid;
  ToggleGridEvent(this.showGrid);

  List<Object?> get props => [showGrid];
}

class ToggleFilledEvent extends DrawingEvent {
  final bool filled;
  ToggleFilledEvent(this.filled);

  List<Object?> get props => [filled];
}

class ChangePolygonSidesEvent extends DrawingEvent {
  final int sides;

  ChangePolygonSidesEvent(this.sides);

  List<Object?> get props => [sides];
}
