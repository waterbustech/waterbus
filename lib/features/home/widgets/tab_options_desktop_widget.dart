// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';

class TabOptionsDesktopWidget extends StatelessWidget {
  final Widget child;
  const TabOptionsDesktopWidget({
    super.key,
    required this.child,
  });

  Widget _buildItemBottomBar({
    required IconData iconData,
    required IconData iconDataSelected,
    required String label,
    int index = 0,
  }) {
    return Expanded(
      child: GestureWrapper(
        onTap: () {
          AppBloc.homeBloc.add(
            OnChangeTabEvent(tabIndex: index),
          );
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final int currentIndex = state.props[0];
            return ColoredBox(
              color: Colors.transparent,
              child: Icon(
                currentIndex == index ? iconDataSelected : iconData,
                size: 20.sp,
                color: currentIndex == index
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).disabledColor,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.sp,
      child: Column(
        children: [
          Expanded(child: child),
          divider,
          Container(
            height: 48.sp,
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItemBottomBar(
                      iconData: PhosphorIcons.presentation,
                      iconDataSelected: PhosphorIcons.presentation_fill,
                      label: Strings.home.i18n,
                    ),
                    _buildItemBottomBar(
                      iconData: PhosphorIcons.chats_teardrop,
                      iconDataSelected: PhosphorIcons.chats_teardrop_fill,
                      label: Strings.chat.i18n,
                      index: 1,
                    ),
                    _buildItemBottomBar(
                      iconData: PhosphorIcons.gear,
                      iconDataSelected: PhosphorIcons.gear_fill,
                      label: Strings.settings.i18n,
                      index: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
