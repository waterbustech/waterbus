import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/profile/widgets/profile_drawer_layout.dart';

class AppDrawer extends StatefulWidget {
  final GlobalKey<SliderDrawerState> sliderDrawerKey;
  final Widget appBar;
  final Widget body;
  const AppDrawer({
    super.key,
    required this.sliderDrawerKey,
    required this.appBar,
    required this.body,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderDrawer(
        key: widget.sliderDrawerKey,
        animationDuration: delay300ms,
        sliderOpenSize: 70.w,
        isCupertino: true,
        slider: ProfileDrawerLayout(
          closeSlider: () {
            widget.sliderDrawerKey.currentState?.closeSlider();
          },
        ),
        appBar: widget.appBar,
        child: widget.body,
      ),
    );
  }
}
