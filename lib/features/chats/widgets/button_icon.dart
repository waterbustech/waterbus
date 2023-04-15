import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';

class ButtonIcon extends StatelessWidget {
  final IconData icon;
  final Color? colorBackground;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  const ButtonIcon({
    super.key,
    required this.icon,
    this.colorBackground,
    this.margin,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(right: 12.sp),
      padding: colorBackground != null ? EdgeInsets.all(5.sp) : null,
      decoration: BoxDecoration(
        color: colorBackground ?? Colors.transparent,
        shape: BoxShape.circle,
        border: border,
      ),
      alignment: Alignment.centerRight,
      child: Icon(
        icon,
        size: colorBackground != null ? 15.sp : 20.sp,
        color: mCL,
      ),
    );
  }
}
