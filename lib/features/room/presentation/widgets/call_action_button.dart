import 'package:flutter/material.dart';

import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final BoxShape shape;
  final double? boxSize;
  final String? tooltipMessage;
  const CallActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.shape = BoxShape.rectangle,
    this.boxSize,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return TooltipWrapper(
      message: tooltipMessage,
      child: _bodyCallActionButton(context),
    );
  }

  Container _bodyCallActionButton(BuildContext context) {
    return Container(
      height: boxSize ?? 42.sp,
      width: boxSize ?? 42.sp,
      margin: shape == BoxShape.circle
          ? EdgeInsets.zero
          : EdgeInsets.only(left: 8.sp),
      child: GestureWrapper(
        onTap: onTap,
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: shape == BoxShape.circle || context.isMobile
              ? const CircleBorder()
              : SuperellipseShape(
                  borderRadius: BorderRadius.circular(20.sp),
                ),
          color:
              backgroundColor ?? Theme.of(context).colorScheme.onInverseSurface,
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).iconTheme.color,
              size: iconSize ?? 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
