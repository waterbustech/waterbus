import 'package:flutter/material.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';

final Divider divider = Divider(
  height: 1.sp,
);

List<BoxShadow> kDefaultShadow(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? []
      : [
          BoxShadow(
            color: const Color(0xFF44475A).withValues(alpha: .5),
            offset: const Offset(0, 2),
            blurRadius: 2,
            spreadRadius: 0.5,
          ),
          BoxShadow(
            color: const Color(0xFF6272A4).withValues(alpha: .2),
            offset: const Offset(0, 1),
            blurRadius: 1,
            spreadRadius: 0.3,
          ),
        ];
}
