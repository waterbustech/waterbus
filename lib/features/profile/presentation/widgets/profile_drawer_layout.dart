// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/profile/presentation/fake/menu_items.dart';
import 'package:waterbus/features/profile/presentation/widgets/list_menu_drawer.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_header.dart';

class ProfileDrawerLayout extends StatelessWidget {
  final Function(MenuItemModel) onTapItem;
  const ProfileDrawerLayout({super.key, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileHeader(),
          if (!SizerUtil.isDesktop)
            Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 20.sp,
                endIndent: 8.sp,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: 20.sp),
            child: ListMenuDrawer(onTapItem: onTapItem),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
