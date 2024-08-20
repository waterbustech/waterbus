part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingChangedEvent extends DrawingEvent {
  final DrawingModel drawingModel;
  OnDrawingChangedEvent({required this.drawingModel});
}

class OnDrawingDeletedEvent extends DrawingEvent {
  final int meetingId;
  OnDrawingDeletedEvent({required this.meetingId});
}
