import 'package:flutter/material.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

class PreviewActionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double? iconSize;
  final BoxShape shape;
  final double? boxSize;
  const PreviewActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.iconSize,
    this.shape = BoxShape.rectangle,
    this.boxSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxSize ?? 42.sp,
      width: boxSize ?? 42.sp,
      margin: shape == BoxShape.circle
          ? EdgeInsets.zero
          : EdgeInsets.only(left: 8.sp),
      child: GestureWrapper(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor ?? mCL),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: iconSize ?? 16.sp,
          ),
        ),
      ),
    );
  }
}
