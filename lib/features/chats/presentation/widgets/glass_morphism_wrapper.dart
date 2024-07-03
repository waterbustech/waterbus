import 'dart:ui';

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
          sigmaX: Theme.of(context).brightness == Brightness.dark ? 12 : 6,
          sigmaY: Theme.of(context).brightness == Brightness.dark ? 12 : 6,
        ),
        child: child,
      ),
    );
  }
}
