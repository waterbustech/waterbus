// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class ButtonLogin extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Function() onPressed;

  const ButtonLogin({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onPressed,
      child: Container(
        width: 300.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.sp),
          color: mCL,
        ),
        padding: EdgeInsets.symmetric(vertical: 11.25.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 62.sp),
            Image.asset(
              iconAsset,
              height: 16.sp,
              width: 16.sp,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10.sp),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.w700,
                fontSize: 11.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
