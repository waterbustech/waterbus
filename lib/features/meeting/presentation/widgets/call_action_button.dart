// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  const CallActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: backgroundColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? mGD.withOpacity(.7)
                  : mCU),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: backgroundColor != null ? mCL : iconColor,
          size: iconSize ?? 18.sp,
        ),
      ),
    );
  }
}
