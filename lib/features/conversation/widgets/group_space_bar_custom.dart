import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:sizer/sizer.dart';

class GroupSpaceBarCustom extends StatefulWidget {
  final Text title;
  final Text? subTitle;
  final Widget? avatar;

  const GroupSpaceBarCustom({
    super.key,
    required this.title,
    this.subTitle,
    this.avatar,
  });

  @override
  State<GroupSpaceBarCustom> createState() => _GroupSpaceBarCustomState();
}

class _GroupSpaceBarCustomState extends State<GroupSpaceBarCustom> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final FlexibleSpaceBarSettings settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

        final List<Widget> children = <Widget>[];

        final ThemeData theme = Theme.of(context);

        final Widget title;
        final Widget? subTitle;

        switch (theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            title = widget.title;
            subTitle = widget.subTitle;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            title = Semantics(
              namesRoute: true,
              child: widget.title,
            );
            subTitle = Semantics(
              namesRoute: true,
              child: widget.subTitle,
            );
        }

        if (settings.toolbarOpacity > 0.0) {
          final TextStyle titleStyle =
              widget.title.style ?? theme.textTheme.titleLarge!;
          final TextStyle? subTitleStyle = widget.subTitle?.style;

          const Alignment titleAlignment = Alignment.bottomCenter;
          final double deltaExtent = settings.maxExtent - settings.minExtent;
          final double paddingBottomAvatar = 16.sp;
          const double expandedTitleScale = 1.5;

          if (widget.avatar != null) {
            final double deltaExtentAvatar = deltaExtent - paddingBottomAvatar;
            final double fadeStart =
                max(0.0, 1.0 - kToolbarHeight / deltaExtentAvatar);
            const double fadeEnd = 1.0;
            final double v = clampDouble(
              1.0 -
                  (settings.currentExtent -
                          paddingBottomAvatar -
                          settings.minExtent) /
                      deltaExtentAvatar,
              0.0,
              1.0,
            );

            final double opacity =
                settings.maxExtent - paddingBottomAvatar == settings.minExtent
                    ? 1.0
                    : 1.0 - Interval(fadeStart, fadeEnd).transform(v);
            final double scaleValueAvatar =
                Tween<double>(begin: expandedTitleScale, end: 1.0).transform(v);
            final Matrix4 scaleTransformAvatar = Matrix4.identity()
              ..scale(scaleValueAvatar, scaleValueAvatar, 1.0);

            children.add(
              _FlexibleSpaceHeaderOpacity(
                opacity: opacity,
                alwaysIncludeSemantics: true,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: (titleStyle.fontSize ?? 0) + 30.sp,
                  ),
                  child: Transform(
                    alignment: titleAlignment,
                    transform: scaleTransformAvatar,
                    child: Align(
                      alignment: titleAlignment,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth / scaleValueAvatar,
                            alignment: titleAlignment,
                            child: widget.avatar,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final double t = clampDouble(
            1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent,
            0.0,
            1.0,
          );

          final double scaleValue =
              Tween<double>(begin: expandedTitleScale, end: 1.0).transform(t);
          final Matrix4 scaleTransform = Matrix4.identity()
            ..scale(scaleValue, scaleValue, 1.0);

          children.add(
            Container(
              padding: EdgeInsets.only(
                bottom: (subTitleStyle?.fontSize ?? 0) + scaleValue * 6.sp,
              ),
              child: Transform(
                alignment: titleAlignment,
                transform: scaleTransform,
                child: Align(
                  alignment: titleAlignment,
                  child: DefaultTextStyle(
                    style: titleStyle,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.maxWidth / scaleValue,
                          alignment: titleAlignment,
                          child: title,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );

          if (subTitle != null && subTitleStyle != null) {
            const double expandedSubTitleScale = 1.25;
            final double scaleSubTitleValue =
                Tween<double>(begin: expandedSubTitleScale, end: 1)
                    .transform(t);
            final Matrix4 scaleTransform = Matrix4.identity()
              ..scale(scaleSubTitleValue, scaleSubTitleValue, 1.0);

            children.add(
              Container(
                padding: EdgeInsets.only(bottom: scaleSubTitleValue * 3.sp),
                child: Transform(
                  alignment: titleAlignment,
                  transform: scaleTransform,
                  child: Align(
                    alignment: titleAlignment,
                    child: DefaultTextStyle(
                      style: subTitleStyle,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            width: constraints.maxWidth / scaleSubTitleValue,
                            alignment: titleAlignment,
                            child: subTitle,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }

        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ClipRect(
            child: Stack(children: children),
          ),
        );
      },
    );
  }
}

class _FlexibleSpaceHeaderOpacity extends SingleChildRenderObjectWidget {
  const _FlexibleSpaceHeaderOpacity({
    required this.opacity,
    required super.child,
    required this.alwaysIncludeSemantics,
  });

  final double opacity;
  final bool alwaysIncludeSemantics;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderFlexibleSpaceHeaderOpacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderFlexibleSpaceHeaderOpacity renderObject,
  ) {
    renderObject
      ..alwaysIncludeSemantics = alwaysIncludeSemantics
      ..opacity = opacity;
  }
}

class _RenderFlexibleSpaceHeaderOpacity extends RenderOpacity {
  _RenderFlexibleSpaceHeaderOpacity({
    super.opacity,
    super.alwaysIncludeSemantics,
  });

  @override
  bool get isRepaintBoundary => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    }
    if ((opacity * 255).roundToDouble() <= 0) {
      layer = null;
      return;
    }
    assert(needsCompositing);
    layer = context.pushOpacity(
      offset,
      (opacity * 255).round(),
      super.paint,
      oldLayer: layer as OpacityLayer?,
    );
    assert(() {
      layer!.debugCreator = debugCreator;
      return true;
    }());
  }
}
