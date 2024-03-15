// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/profile/presentation/fake/fake_menu_items.dart';
import 'package:waterbus/features/profile/presentation/widgets/list_menu_drawer.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_header.dart';
import 'package:waterbus/features/profile/presentation/widgets/version_info_footer.dart';

class ProfileDrawerLayout extends StatelessWidget {
  final Function(MenuItemModel) onTapItem;
  const ProfileDrawerLayout({super.key, required this.onTapItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.sp,
        right: 8.sp,
        top: SizerUtil.isDesktop ? 10.sp : 0,
      ),
      color: Colors.black,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            Padding(
              padding: EdgeInsets.only(top: 20.sp, bottom: 8.sp),
              child: const Divider(
                height: .5,
                thickness: .5,
              ),
            ),
            ListMenuDrawer(onTapItem: onTapItem),
            const Spacer(),
            const VersionInfoFooter(),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }
}
