part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingChangedEvent extends DrawingEvent {
  final List<Offset?> points;
  OnDrawingChangedEvent({required this.points});
}

class OnDrawingDeletedEvent extends DrawingEvent {}
