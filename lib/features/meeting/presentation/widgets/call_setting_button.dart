import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class CallSettingButton extends StatelessWidget {
  final IconData icon;
  final String lable;
  final Function() onTap;
  final bool visible;
  final bool hasDivider;
  const CallSettingButton({
    super.key,
    required this.icon,
    required this.lable,
    required this.onTap,
    this.visible = true,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureWrapper(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.sp,
            horizontal: 16.sp,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: hasDivider
                ? Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              SizedBox(width: 10.sp),
              Text(
                lable,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
