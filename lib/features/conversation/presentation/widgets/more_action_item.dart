import 'package:flutter/material.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

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
      onTap: () {
        AppRouter.pop();

        onTap?.call();
      },
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
                color: textColor ?? colorRedRemove,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 2.0.sp),
              child: Icon(
                icon,
                color: iconColor ?? colorRedRemove,
                size: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
