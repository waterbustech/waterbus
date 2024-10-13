part of 'drawing_bloc.dart';

class DrawingEvent {}

class OnDrawingInitEvent extends DrawingEvent {
  final int meetingId;
  OnDrawingInitEvent({
    required this.meetingId,
  });
}

class OnDrawingChangedEvent extends DrawingEvent {
  final UpdateDrawEnum action;
  final DrawModel drawingModel;
  OnDrawingChangedEvent({
    required this.drawingModel,
    required this.action,
  });
}

class OnDrawingDeletedEvent extends DrawingEvent {
  final int meetingId;
  OnDrawingDeletedEvent({required this.meetingId});
}

class OnRemoteDrawingInitEvent extends DrawingEvent {
  final List<DrawModel> points;
  OnRemoteDrawingInitEvent({required this.points});
}

class OnRemoteDrawingChangedEvent extends DrawingEvent {
  final List<DrawModel> points;
  OnRemoteDrawingChangedEvent({required this.points});
}

class OnRemoteDrawingDeletedEvent extends DrawingEvent {
  OnRemoteDrawingDeletedEvent();
}
