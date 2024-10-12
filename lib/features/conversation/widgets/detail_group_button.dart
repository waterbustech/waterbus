import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class DetailGroupButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function()? onTap;

  const DetailGroupButton({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        width: 64.sp,
        decoration: ShapeDecoration(
          shape: SuperellipseShape(
            borderRadius: BorderRadius.circular(25.sp),
          ),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 2.sp),
            Text(
              title.toLowerCase(),
              style: TextStyle(
                fontSize: 9.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
