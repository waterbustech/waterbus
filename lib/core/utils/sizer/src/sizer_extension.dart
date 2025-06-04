import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';

class SizerExtension extends ThemeExtension<SizerExtension> {
  final BoxConstraints constraints;
  final Orientation orientation;
  late final ScreenType _screenType;

  SizerExtension({
    required this.constraints,
    required this.orientation,
  }) {
    _screenType = SizerUtils.instance.getScreenType(
      size,
      orientation,
    );
  }

  ScreenType get screenType => _screenType;

  @override
  SizerExtension copyWith({
    BoxConstraints? constraints,
    Orientation? orientation,
  }) {
    return SizerExtension(
      constraints: constraints ?? this.constraints,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  SizerExtension lerp(
    covariant ThemeExtension<SizerExtension>? other,
    double t,
  ) {
    if (other == null || other is! SizerExtension) return this;

    // Lerp constraints
    final lerpConstraints = BoxConstraints(
      minWidth:
          lerpDouble(constraints.minWidth, other.constraints.minWidth, t)!,
      maxWidth:
          lerpDouble(constraints.maxWidth, other.constraints.maxWidth, t)!,
      minHeight:
          lerpDouble(constraints.minHeight, other.constraints.minHeight, t)!,
      maxHeight:
          lerpDouble(constraints.maxHeight, other.constraints.maxHeight, t)!,
    );

    // Lerp orientation
    final lerpOrientation = t < 0.5 ? orientation : other.orientation;

    return SizerExtension(
      constraints: lerpConstraints,
      orientation: lerpOrientation,
    );
  }

  bool get isDesktop => screenType != ScreenType.mobile;

  bool get isMobile => screenType == ScreenType.mobile;

  bool get isLandscape => orientation == Orientation.landscape;

  Size get size => Size(constraints.maxWidth, constraints.maxHeight);
}
