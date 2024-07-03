import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

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
        AppNavigator.pop();
        handlePressed?.call();
      },
      child: Container(
        height: 42.sp,
        alignment: Alignment.center,
        color: (Theme.of(context).brightness == Brightness.dark
                ? colorBlackGlassmorphism
                : Theme.of(context).scaffoldBackgroundColor)
            .withOpacity(0.7),
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
