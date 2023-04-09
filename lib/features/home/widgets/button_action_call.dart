import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';

class ButtonActionCall extends StatelessWidget {
  final IconData icon;
  const ButtonActionCall({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: mGD.withOpacity(.7),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: mCL,
        size: 16.sp,
      ),
    );
  }
}
