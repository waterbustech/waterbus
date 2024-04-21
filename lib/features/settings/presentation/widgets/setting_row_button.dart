// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/common/styles/style.dart';

class SettingRowButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  final Color iconBackground;
  final bool isLast;
  final bool isFirst;
  const SettingRowButton({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.iconBackground,
    this.isLast = true,
    this.isFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isFirst ? 7.sp : 0),
            bottom: Radius.circular(isLast ? 7.sp : 0),
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.sp),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12.sp),
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.5.sp),
                      child: Icon(
                        icon,
                        color: mCL,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6.sp),
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: colorGray3,
                    ),
                  ),
                ],
              ),
            ),
            if ((isFirst && !isLast) || (!isFirst && !isLast))
              Padding(padding: EdgeInsets.only(left: 43.5.sp), child: divider),
          ],
        ),
      ),
    );
  }
}
