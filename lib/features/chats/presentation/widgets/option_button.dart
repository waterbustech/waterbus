import 'package:flutter/material.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

class ButtonOptionWidget extends StatelessWidget {
  final String text;
  final Function()? handlePressed;
  final bool isDanger;

  const ButtonOptionWidget({
    super.key,
    required this.text,
    this.handlePressed,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: () {
        AppRouter.pop();
        handlePressed?.call();
      },
      child: Container(
        height: 42.sp,
        alignment: Alignment.center,
        color: Theme.of(context)
            .colorScheme
            .surfaceContainer
            .withValues(alpha: 0.7),
        child: Text(
          text,
          style: TextStyle(
            color: isDanger ? colorHigh : Theme.of(context).colorScheme.primary,
            fontSize: 13.25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
