import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class BackgroundGalleryScreen extends StatefulWidget {
  const BackgroundGalleryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BackgroundGalleryScreenState();
}

class _BackgroundGalleryScreenState extends State<BackgroundGalleryScreen> {
  String? _currentBackground;

  @override
  void initState() {
    super.initState();

    _currentBackground = AppBloc.meetingBloc.currentBackground;
  }

  List<String> get backgroundAssets =>
      SizerUtil.isDesktop ? desktopBackgrounds : backgrounds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.virtualBackground.i18n,
        actions: [
          IconButton(
            onPressed: () {
              AppBloc.meetingBloc.add(
                ApplyVirtualBackgroundEvent(_currentBackground),
              );
              AppNavigator.pop();
            },
            icon: Icon(
              PhosphorIcons.check,
              size: 18.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: SizerUtil.isDesktop ? (100.w / 250.sp).round() : 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2.sp,
          childAspectRatio: SizerUtil.isDesktop ? 1.78 : 0.66,
        ),
        itemCount: backgroundAssets.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureWrapper(
              onTap: () {
                setState(() {
                  _currentBackground = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: _currentBackground == null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.block,
                  size: 20.sp,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            );
          }

          return GestureWrapper(
            onTap: () {
              setState(() {
                _currentBackground = backgroundAssets[index - 1];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.sp,
                  color: _currentBackground == backgroundAssets[index - 1]
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Image.asset(
                backgroundAssets[index - 1],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
