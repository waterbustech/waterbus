import 'dart:ui';

class DrawingModel {
  final int meetingId;
  List<Offset> points;
  final Color color;
  DrawingModel({
    required this.meetingId,
    List<Offset>? points,
    required this.color,
  }) : points = points ?? [];

  DrawingModel copyWith({List<Offset>? offsets}) {
    return DrawingModel(
      meetingId: meetingId,
      color: color,
      points: offsets,
    );
  }
}
