import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class CallSettingButton extends StatelessWidget {
  final IconData icon;
  final String lable;
  final Function() onTap;
  final Color? color;
  const CallSettingButton({
    super.key,
    required this.icon,
    required this.lable,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.sp,
          horizontal: 16.sp,
        ),
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
            ),
            SizedBox(height: 8.sp),
            Text(
              lable,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: color,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
