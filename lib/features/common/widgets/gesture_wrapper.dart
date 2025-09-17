import 'package:flutter/material.dart';

import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

class GestureWrapper extends StatefulWidget {
  final Function? onTap;
  final Function? onSecondaryTap;
  final Function? onLongPress;
  final Widget child;
  final bool isCloseKeyboard;
  final bool isHovered;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.isCloseKeyboard = true,
    this.isHovered = false,
  });

  @override
  State<GestureWrapper> createState() => _GestureWrapperState();
}

class _GestureWrapperState extends State<GestureWrapper> {
  bool _enable = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onLongPress != null
          ? () {
              if (!_enable) {
                widget.onLongPress!();
              }
            }
          : null,
      onTap: widget.onTap != null ||
              (FocusScope.of(context).hasFocus && widget.isCloseKeyboard)
          ? () {
              if (FocusScope.of(context).hasFocus && widget.isCloseKeyboard) {
                FocusScope.of(context).unfocus();
              }

              if (!_enable && widget.onTap != null) {
                widget.onTap?.call();
              }
            }
          : null,
      onTapDown: (a) {
        setState(() {
          _enable = true;
        });
      },
      onTapUp: (a) {
        setState(() {
          _enable = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _enable = false;
        });
      },
      onSecondaryTap: widget.onSecondaryTap != null ||
              (FocusScope.of(context).hasFocus && widget.isCloseKeyboard)
          ? () {
              if (FocusScope.of(context).hasFocus && widget.isCloseKeyboard) {
                FocusScope.of(context).unfocus();
              }

              if (!_enable && widget.onSecondaryTap != null) {
                widget.onSecondaryTap!();
              }
            }
          : null,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _enable = true;
          });
        },
        onExit: (_) {
          setState(() {
            _enable = false;
          });
        },
        child: widget.isHovered
            ? AnimatedContainer(
                duration: 100.milliseconds,
                decoration: BoxDecoration(
                  color: _enable
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.25)
                      : Colors.transparent,
                ),
                child: widget.child,
              )
            : Opacity(opacity: _enable ? 0.5 : 1, child: widget.child),
      ),
    );
  }
}
