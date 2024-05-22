import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.sp),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
            ),
      ),
    );
  }
}
