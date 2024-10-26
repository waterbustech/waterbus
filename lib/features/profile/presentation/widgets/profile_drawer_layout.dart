import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/features/profile/presentation/models/menu_items.dart';
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
