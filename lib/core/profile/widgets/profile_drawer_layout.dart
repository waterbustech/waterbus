// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/profile/widgets/list_menu_drawer.dart';
import 'package:waterbus/core/profile/widgets/profile_header.dart';

class ProfileDrawerLayout extends StatelessWidget {
  final Function() closeSlider;
  const ProfileDrawerLayout({
    super.key,
    required this.closeSlider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        const int sensitivity = -15;

        if (details.delta.dx < sensitivity) {
          //SWIPE FROM RIGHT TO LEFT DETECTION
          closeSlider();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.sp, right: 8.sp),
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
              const ListMenuDrawer(),
            ],
          ),
        ),
      ),
    );
  }
}
