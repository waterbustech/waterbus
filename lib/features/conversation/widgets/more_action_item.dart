import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class MoreActionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final double? sizeIcon;
  final Color? iconColor;
  final Color? textColor;
  final Function()? onTap;

  const MoreActionItem({
    super.key,
    required this.title,
    required this.icon,
    this.sizeIcon,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: textColor ?? const Color(0xFFF85E53),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 2.0.sp),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFFF85E53),
                size: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
