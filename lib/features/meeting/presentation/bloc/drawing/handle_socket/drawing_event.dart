part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingInitEvent extends DrawingEvent {
  final Stroke drawingModel;
  final int? polygonSides;
  final bool? fillShape;
  OnDrawingInitEvent(
      {required this.drawingModel,
      required this.polygonSides,
      required this.fillShape});
}

class OnDrawingChangedEvent extends DrawingEvent {
  final Stroke drawingModel;
  OnDrawingChangedEvent({
    required this.drawingModel,
  });
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
