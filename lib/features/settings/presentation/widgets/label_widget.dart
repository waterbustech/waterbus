import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class LabelWidget extends StatelessWidget {
  final String label;

  const LabelWidget({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp).add(
        EdgeInsets.symmetric(horizontal: 12.sp),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }
}
