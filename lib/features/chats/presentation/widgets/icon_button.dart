import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class IconButtonCustom extends StatelessWidget {
  final IconData icon;
  final Color? colorBackground;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final double? sizeIcon;
  final EdgeInsetsGeometry? padding;
  final Color? colorIcon;
  final Function()? onTap;

  const IconButtonCustom({
    super.key,
    required this.icon,
    this.colorBackground,
    this.margin,
    this.border,
    this.sizeIcon,
    this.padding,
    this.colorIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.only(right: 12.sp),
        padding:
            padding ?? (colorBackground != null ? EdgeInsets.all(5.sp) : null),
        decoration: BoxDecoration(
          color: colorBackground ?? Colors.transparent,
          shape: BoxShape.circle,
          border: border,
        ),
        alignment: Alignment.centerRight,
        child: Icon(
          icon,
          size: sizeIcon ?? (colorBackground != null ? 15.sp : 20.sp),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
