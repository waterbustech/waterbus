import 'package:flutter/material.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';

class CustomRowButton extends StatelessWidget {
  final Function() onTap;
  final dynamic value;
  final String text;
  final bool showDivider;
  final String? groupValue;
  const CustomRowButton({
    super.key,
    required this.onTap,
    this.value,
    required this.text,
    required this.showDivider,
    this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureWrapper(
          onTap: () => onTap.call(),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 10.sp),
            color: Colors.transparent,
            child: Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: value,
                  groupValue: groupValue,
                  onChanged: (value) => onTap.call(),
                ),
                SizedBox(width: 8.sp),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.only(left: 36.sp),
            child: divider,
          ),
      ],
    );
  }
}
