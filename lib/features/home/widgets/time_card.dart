// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

class TimeCard extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  const TimeCard({
    super.key,
    required this.text,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.sp),
      padding: EdgeInsets.symmetric(
        horizontal: 14.sp,
        vertical: 6.sp,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).primaryColorLight.withOpacity(.08),
        borderRadius: BorderRadius.circular(30.sp),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 9.sp,
            ),
      ),
    );
  }
}
