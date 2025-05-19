import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class E2eeLabelLine extends StatelessWidget {
  final IconData icon;
  final String label;

  const E2eeLabelLine({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
        SizedBox(width: 12.sp),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
      ],
    );
  }
}
