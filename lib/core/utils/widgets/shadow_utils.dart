import 'package:flutter/material.dart';

class ShadowUtils {
  List<BoxShadow> get shadowButton {
    return const [
      BoxShadow(
        color: Colors.black54,
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ];
  }
}
