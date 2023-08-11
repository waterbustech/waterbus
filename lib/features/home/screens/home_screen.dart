// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_sliding_drawer/flutter_sliding_drawer.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/home/widgets/my_meetings.dart';
import 'package:waterbus/features/profile/presentation/widgets/profile_drawer_layout.dart';
import 'package:waterbus/gen/assets.gen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SlidingDrawerState> _sideMenuKey =
      GlobalKey<SlidingDrawerState>();

  void _toggleDrawer() {
    final state = _sideMenuKey.currentState;

    if (state == null) return;
    if (state.isOpen) {
      state.closeSlidingDrawer(); // close side menu
    } else {
      state.openSlidingDrawer(); // open side menu
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingDrawer(
      key: _sideMenuKey,
      drawerBuilder: (_) => const ProfileDrawerLayout(),
      contentBuilder: (_) => Scaffold(
        appBar: appBarTitleBack(
          context,
          '',
          centerTitle: false,
          isVisibleBackButton: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          titleWidget: Row(
            children: [
              SizedBox(width: 6.sp),
              GestureDetector(
                onTap: _toggleDrawer,
                child: CustomNetworkImage(
                  height: 30.sp,
                  width: 30.sp,
                  urlToImage:
                      'https://avatars.githubusercontent.com/u/60530946?v=4',
                ),
              ),
              SizedBox(width: 10.sp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Kai Dao",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    "Senior at Waterbus",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 10.sp,
                        ),
                  )
                ],
              ),
            ],
          ),
          actions: [
            Container(
              width: 36.sp,
              height: 36.sp,
              margin: EdgeInsets.only(right: 16.sp),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.centerRight,
              child: Image.asset(
                Assets.icons.icNewMeeting.path,
                height: 22.sp,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
        body: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              SizedBox(height: 16.sp),
              EnterCodeBox(
                onTap: () {
                  AppNavigator.push(Routes.enterCodeRoute);
                },
              ),
              SizedBox(height: 16.sp),
              const Divider(thickness: .3, height: .3),
              SizedBox(height: 10.sp),
              const Expanded(
                child: MyMeetings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
