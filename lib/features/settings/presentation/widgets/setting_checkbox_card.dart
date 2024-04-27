// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class SettingCheckboxCard extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool hasDivider;
  final Function() onTap;
  const SettingCheckboxCard({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: hasDivider
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 12.sp,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10.sp,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            enabled
                ? Icon(
                    PhosphorIcons.check,
                    color: Colors.green,
                    size: 16.sp,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
