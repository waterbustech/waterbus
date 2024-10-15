import 'dart:ui';

class DrawingModel {
  final int participantId;
  List<Offset> points;
  final Color color;
  DrawingModel({
    required this.participantId,
    List<Offset>? points,
    required this.color,
  }) : points = points ?? [];

  DrawingModel copyWith({List<Offset>? offsets}) {
    return DrawingModel(
      participantId: participantId,
      color: color,
      points: offsets,
    );
  }
}
