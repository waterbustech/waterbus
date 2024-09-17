import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/navigator/app_navigator.dart';

enum FadeTheme { light, dark, lightReverse }

enum ShimmerDirection { ltr, rtl, ttb, btt }

@immutable
class FadeShimmer extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius radius;
  final Gradient gradient;
  final bool enabled;
  final Duration period;
  final ShimmerDirection direction;
  final BoxShape shape;

  /// light or dark with predefined highlightColor and baseColor
  /// need to pass this or highlightColor and baseColor
  final FadeTheme? fadeTheme;

  FadeShimmer({
    super.key,
    this.enabled = true,
    this.shape = BoxShape.rectangle,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.fadeTheme,
    this.width,
    this.height,
    Color? highlightColor,
    Color? baseColor,
    BorderRadius? borderRadius,
  })  : radius = borderRadius ?? BorderRadius.circular(10),
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            fadeTheme.baseColor ?? baseColor!,
            fadeTheme.baseColor ?? baseColor!,
            fadeTheme.highLightColor ?? highlightColor!,
            fadeTheme.baseColor ?? baseColor!,
            fadeTheme.baseColor ?? baseColor!,
          ],
          stops: const <double>[0.0, 0.35, 0.5, 0.65, 1.0],
        ) {
    assert(
      (highlightColor != null && baseColor != null) || fadeTheme != null,
    );
  }

  /// use this to create a round loading widget
  factory FadeShimmer.round({
    required double size,
    Color? highlightColor,
    int millisecondsDelay = 0,
    Color? baseColor,
    FadeTheme? fadeTheme,
  }) =>
      FadeShimmer(
        height: size,
        width: size,
        baseColor: baseColor,
        highlightColor: highlightColor,
        fadeTheme: fadeTheme,
        shape: BoxShape.circle,
      );

  @override
  State<FadeShimmer> createState() => _FadeShimmerState();
}

class _FadeShimmerState extends State<FadeShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period)
        ..forward()
        ..addStatusListener((status) {
          if (status != AnimationStatus.completed) {
            return;
          }

          _controller.repeat();
        });

  @override
  void didUpdateWidget(FadeShimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Material(
        color: widget.gradient.colors.first,
        clipBehavior: Clip.hardEdge,
        shape: widget.shape == BoxShape.rectangle
            ? SuperellipseShape(borderRadius: widget.radius)
            : const CircleBorder(),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
        ),
      ),
      builder: (context, child) => _Shimmer(
        direction: widget.direction,
        gradient: widget.gradient,
        percent: _controller.value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

extension ColorX on FadeTheme? {
  Color? get highLightColor {
    if (this != null) {
      switch (this) {
        case FadeTheme.light:
          return const Color(0xffF9F9FB);
        case FadeTheme.dark:
          return const Color(0xff3A3E3F);
        case FadeTheme.lightReverse:
          return Theme.of(AppNavigator.context!).brightness == Brightness.dark
              ? const Color(0xff393e47)
              : const Color(0xffEAEAEA);
        default:
          return const Color(0xff3A3E3F);
      }
    }
    return null;
  }

  Color? get baseColor {
    if (this != null) {
      switch (this) {
        case FadeTheme.light:
          return const Color(0xffE6E8EB);
        case FadeTheme.dark:
          return const Color(0xff2A2C2E);
        case FadeTheme.lightReverse:
          return Theme.of(AppNavigator.context!).brightness == Brightness.dark
              ? const Color(0xff3d3d5c)
              : const Color(0xFFD6DFDC);
        default:
          return const Color(0xff2A2C2E);
      }
    }
    return null;
  }
}

@immutable
class _Shimmer extends SingleChildRenderObjectWidget {
  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  const _Shimmer({
    super.child,
    required this.percent,
    required this.direction,
    required this.gradient,
  });

  @override
  _ShimmerFilter createRenderObject(BuildContext context) {
    return _ShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, this._direction, this._gradient);

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) {
      return;
    }
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(needsCompositing);

    final double width = size.width;
    final double height = size.height;

    Rect rect;
    double dx, dy;

    if (_direction == ShimmerDirection.rtl) {
      dx = _offset(width, -width, _percent);
      dy = 0.0;
      rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
    } else if (_direction == ShimmerDirection.ttb) {
      dx = 0.0;
      dy = _offset(-height, height, _percent);
      rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
    } else if (_direction == ShimmerDirection.btt) {
      dx = 0.0;
      dy = _offset(height, -height, _percent);
      rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
    } else {
      dx = _offset(-width, width, _percent);
      dy = 0.0;
      rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
    }

    layer ??= ShaderMaskLayer();
    layer!
      ..shader = _gradient.createShader(rect)
      ..maskRect = offset & size
      ..blendMode = BlendMode.srcIn;
    context.pushLayer(layer!, super.paint, offset);
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
