import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final BoxShape shape;
  const CallActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.sp,
      width: 42.sp,
      margin: shape == BoxShape.circle
          ? EdgeInsets.zero
          : EdgeInsets.only(left: 8.sp),
      child: GestureWrapper(
        onTap: onTap,
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: shape == BoxShape.circle || SizerUtil.isMobile
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
              color: backgroundColor != null ? mCL : iconColor,
              size: iconSize ?? 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
