import 'package:flutter/material.dart';

class DraggableBox extends StatefulWidget {
  final GlobalKey parentKey;
  final Widget child;
  final Size size;
  final Offset initialOffset;
  final VoidCallback? onTap;
  final bool snap;
  final EdgeInsets margin;
  final BoxDecoration? decoration;
  final bool useSafeAreaClamp;

  const DraggableBox({
    super.key,
    required this.parentKey,
    required this.child,
    this.size = const Size(160, 56),
    this.initialOffset = const Offset(24, 160),
    this.onTap,
    this.snap = true,
    this.margin = const EdgeInsets.all(8),
    this.decoration,
    this.useSafeAreaClamp = true,
  });

  @override
  State<DraggableBox> createState() => _DraggableBoxState();
}

class _DraggableBoxState extends State<DraggableBox> {
  late Offset _pos = widget.initialOffset;
  Offset _dragOffset = Offset.zero;

  Rect _parentBounds(BuildContext context) {
    final ctx = widget.parentKey.currentContext!;
    final parentBox = ctx.findRenderObject() as RenderBox;
    final size = parentBox.size;

    final mq = MediaQuery.of(ctx);
    final insetTop = widget.useSafeAreaClamp ? mq.padding.top : 0.0;
    final insetBottom = widget.useSafeAreaClamp ? mq.padding.bottom : 0.0;

    final left = widget.margin.left;
    final top = insetTop + widget.margin.top;
    final right = size.width - widget.size.width - widget.margin.right;
    final bottom =
        size.height - insetBottom - widget.size.height - widget.margin.bottom;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  void _onPanStart(DragStartDetails details) {
    _dragOffset = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final ctx = widget.parentKey.currentContext!;
    final parentBox = ctx.findRenderObject() as RenderBox;
    final localInParent = parentBox.globalToLocal(details.globalPosition);

    final bounds = _parentBounds(context);
    final next = Offset(
      localInParent.dx - _dragOffset.dx,
      localInParent.dy - _dragOffset.dy,
    );

    setState(() {
      _pos = Offset(
        next.dx.clamp(bounds.left, bounds.right),
        next.dy.clamp(bounds.top, bounds.bottom),
      );
    });
  }

  void _onPanEnd(_) {
    if (!widget.snap) return;
    final bounds = _parentBounds(context);
    final parentWidth = bounds.right -
        bounds.left +
        widget.size.width +
        widget.margin.horizontal;
    final midX = (parentWidth - widget.size.width) / 2;
    final targetX = _pos.dx <= midX ? bounds.left : bounds.right;

    setState(() {
      _pos = Offset(targetX, _pos.dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _pos.dx,
      top: _pos.dy,
      width: widget.size.width,
      height: widget.size.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: DecoratedBox(
          decoration: widget.decoration ?? BoxDecoration(),
          child: Material(color: Colors.transparent, child: widget.child),
        ),
      ),
    );
  }
}
