import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/home/screens/home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabs = [
    const HomeScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          height: Platform.isIOS ? 64.sp : 60.sp,
          padding: EdgeInsets.symmetric(horizontal: 6.5.sp).add(
            EdgeInsets.only(bottom: Platform.isIOS ? 14.sp : 12.sp),
          ),
          alignment: Alignment.center,
          child: Container(
            width: SizerUtil.isTablet ? 60.w : double.infinity,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildItemBottomBar(
                  iconData: PhosphorIcons.house,
                  iconDataSelected: PhosphorIcons.house_bold,
                  index: 0,
                ),
                _buildItemBottomBar(
                  iconData: PhosphorIcons.calendar,
                  iconDataSelected: PhosphorIcons.calendar_bold,
                  index: 1,
                ),
                _buildItemBottomBar(
                  iconData: PhosphorIcons.bell,
                  iconDataSelected: PhosphorIcons.bell_bold,
                  index: 2,
                ),
                _buildItemBottomBar(
                  iconData: PhosphorIcons.user,
                  iconDataSelected: PhosphorIcons.user_bold,
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return _tabs[state.props[0]];
        },
      ),
    );
  }

  Widget _buildItemBottomBar({
    required IconData iconData,
    required IconData iconDataSelected,
    int index = 0,
  }) {
    return Expanded(
      child: GestureDetector(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColoredBox(
                    color: Colors.transparent,
                    child: Icon(
                      currentIndex == index ? iconDataSelected : iconData,
                      size: 21.sp,
                      color: currentIndex == index
                          ? Theme.of(context)
                              .bottomNavigationBarTheme
                              .selectedItemColor
                          : Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
