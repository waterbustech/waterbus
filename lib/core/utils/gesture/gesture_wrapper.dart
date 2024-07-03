import 'package:flutter/material.dart';

class GestureWrapper extends StatefulWidget {
  final Function? onTap;
  final Function? onLongPress;
  final Widget child;
  final bool isCloseKeyboard;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onTap,
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
      onLongPress: () {
        if (!_enable && widget.onLongPress != null) {
          widget.onLongPress!();
        }
      },
      onTap: () {
        if (widget.isCloseKeyboard) {
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
          }
        }

        if (!_enable && widget.onTap != null) {
          widget.onTap!();
        }
      },
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
      child: Opacity(opacity: _enable ? 0.5 : 1, child: widget.child),
    );
  }
}
