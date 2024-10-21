import 'package:flutter/material.dart';

class GestureWrapper extends StatefulWidget {
  final Function? onTap;
  final Function? onSecondaryTap;
  final Function? onLongPress;
  final Widget child;
  final bool isCloseKeyboard;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onSecondaryTap,
    this.onLongPress,
    this.isCloseKeyboard = true,
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
                widget.onTap!();
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
      child: Opacity(opacity: _enable ? 0.5 : 1, child: widget.child),
    );
  }
}
