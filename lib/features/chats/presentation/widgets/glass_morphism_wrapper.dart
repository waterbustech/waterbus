// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

class GlassmorphismWrapper extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;

  const GlassmorphismWrapper({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: Theme.of(context).brightness == Brightness.dark ? 20 : 10,
          sigmaY: Theme.of(context).brightness == Brightness.dark ? 40 : 20,
        ),
        child: child,
      ),
    );
  }
}
