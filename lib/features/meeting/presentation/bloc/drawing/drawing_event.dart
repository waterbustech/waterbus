part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingInitEvent extends DrawingEvent {
  final List<DrawingModel?> drawingModel;
  OnDrawingInitEvent({required this.drawingModel});
}

class OnDrawingChangedEvent extends DrawingEvent {
  final List<DrawingModel?> drawingModel;
  OnDrawingChangedEvent({required this.drawingModel});
}

class OnDrawingDeletedEvent extends DrawingEvent {
  final int meetingId;
  OnDrawingDeletedEvent({required this.meetingId});
}

class OnAnotherDrawingChangedEvent extends DrawingEvent {
  final List<Offset?> points;
  OnAnotherDrawingChangedEvent({required this.points});
}

class OnAnotherDrawingDeletedEvent extends DrawingEvent {
  OnAnotherDrawingDeletedEvent();
}
