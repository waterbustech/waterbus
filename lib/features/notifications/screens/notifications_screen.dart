// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/widgets/app_drawer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppDrawer(
        sliderDrawerKey: _sliderDrawerKey,
        appBar: appBarTitleBack(
          context,
          'Notifications',
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: GestureWrapper(
            onTap: () {
              _sliderDrawerKey.currentState?.toggle();
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: CustomNetworkImage(
                height: 24.sp,
                urlToImage:
                    'https://avatars.githubusercontent.com/u/60530946?v=4',
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                PhosphorIcons.sliders_horizontal_fill,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ],
        ),
        body: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: const [
              Divider(height: .5, thickness: .5),
            ],
          ),
        ),
      ),
    );
  }
}
