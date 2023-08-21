// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Notifications',
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: Container(
          alignment: Alignment.centerRight,
          child: CustomNetworkImage(
            height: 24.sp,
            urlToImage: 'https://avatars.githubusercontent.com/u/60530946?v=4',
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
        child: const Column(
          children: [
            Divider(height: .5, thickness: .5),
          ],
        ),
      ),
    );
  }
}
