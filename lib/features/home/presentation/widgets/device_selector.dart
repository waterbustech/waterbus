import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

class DeviceSelector extends StatelessWidget {
  final IconData icon;
  final String text;
  const DeviceSelector({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.sp,
      padding: EdgeInsets.symmetric(
        horizontal: 10.sp,
        vertical: 6.sp,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: colorGray2),
      ),
      child: Row(
        children: [
          PhosphorIcon(
            icon,
            size: 16.sp,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          SizedBox(width: 8.sp),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
          SizedBox(width: 4.sp),
          PhosphorIcon(
            PhosphorIcons.caretDown(PhosphorIconsStyle.fill),
            size: 10.sp,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ],
      ),
    );
  }
}
