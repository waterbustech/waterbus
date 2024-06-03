import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

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
          borderRadius: BorderRadius.circular(4.sp),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.sp,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 11.25.sp,
          horizontal: 12.sp,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconAsset,
              height: 16.sp,
              width: 16.sp,
              fit: BoxFit.contain,
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
