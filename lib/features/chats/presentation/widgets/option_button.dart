// Flutter imports:
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class ButtonOptionWidget extends StatelessWidget {
  final String text;
  final Function()? handlePressed;
  final bool isDanger;
  final bool isCancel;
  const ButtonOptionWidget({
    super.key,
    required this.text,
    this.handlePressed,
    this.isDanger = false,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: () {
        AppNavigator.pop();
        handlePressed?.call();
      },
      child: Container(
        height: 46.sp,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Text(
          text,
          style: TextStyle(
            color: isDanger
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 13.25.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
