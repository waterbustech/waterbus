import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/profile/fake/fake_menu_items.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class MenuDrawerCard extends StatelessWidget {
  final MenuItemModel item;
  const MenuDrawerCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12.sp),
        child: Row(
          children: [
            Icon(
              item.iconData,
              size: 22.sp,
              color: Colors.white,
            ),
            SizedBox(width: 10.sp),
            Text(
              item.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
