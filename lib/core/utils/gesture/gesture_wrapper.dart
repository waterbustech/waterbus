import 'package:flutter/material.dart';

class GestureWrapper extends StatefulWidget {
  final Function? onTap;
  final Function? onLongPress;
  final Widget child;

  const GestureWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<GestureWrapper> createState() => _GestureWrapperState();
}

class _GestureWrapperState extends State<GestureWrapper> {
  bool enable = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!enable && widget.onLongPress != null) {
          widget.onLongPress!();
        }
      },
      onTap: () {
        if (!enable && widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapDown: (a) {
        setState(() {
          enable = true;
        });
      },
      onTapUp: (a) {
        setState(() {
          enable = false;
        });
      },
      onTapCancel: () {
        setState(() {
          enable = false;
        });
      },
      child: Opacity(opacity: enable ? 0.5 : 1, child: widget.child),
    );
  }
}
