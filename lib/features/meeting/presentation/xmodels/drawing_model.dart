import 'package:flutter/widgets.dart';

class DrawingModel {
  final int meetingId;
  final List<Offset?> points;

  DrawingModel({required this.meetingId, required this.points});
}
