import 'package:flutter/material.dart';

import 'package:waterbus_sdk/types/enums/draw_types.dart';
import 'package:waterbus_sdk/types/models/draw_model.dart';

class CurrentStroke {
  DrawModel? value;

  bool get hasStroke => value != null;

  void startStroke(
    Offset point, {
    Color color = Colors.blueAccent,
    double size = 10,
    double opacity = 1,
    DrawTypes type = DrawTypes.normal,
    int? sides,
    bool? filled,
  }) {
    value = () {
      if (type == DrawTypes.eraser) {
        return EraserStroke(
          points: [point],
          color: color,
          size: size,
        );
      }

      if (type == DrawTypes.line) {
        return LineStroke(
          points: [point],
          color: color,
          size: size,
        );
      }

      if (type == DrawTypes.polygon) {
        return PolygonStroke(
          points: [point],
          color: color,
          size: size,
          sides: sides ?? 3,
          filled: filled ?? false,
        );
      }

      if (type == DrawTypes.circle) {
        return CircleStroke(
          points: [point],
          color: color,
          size: size,
          filled: filled ?? false,
        );
      }

      if (type == DrawTypes.square) {
        return SquareStroke(
          points: [point],
          color: color,
          size: size,
          filled: filled ?? false,
        );
      }

      return NormalStroke(
        points: [point],
        color: color,
        size: size,
      );
    }();
  }

  void addPoint(Offset point) {
    final points = List<Offset>.from(value?.points ?? [])..add(point);
    value = value?.copyWith(points: points);
  }

  void clear() {
    value = null;
  }
}
