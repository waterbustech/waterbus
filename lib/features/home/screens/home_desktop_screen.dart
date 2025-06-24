import 'package:flutter/material.dart';

import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/home/widgets/side_menu_widget.dart';
import 'package:waterbus/features/home/xmodels/home_page_enum.dart';

class HomeDesktopScreen extends StatefulWidget {
  final Widget Function(BuildContext, String) header;
  const HomeDesktopScreen({super.key, required this.header});

  @override
  State<HomeDesktopScreen> createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen> {
  int _currentTab = 0;

  late final List<Widget> children =
      HomePageEnum.values.map((page) => page.screen).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.sp),
            color: Theme.of(context).colorScheme.outlineVariant,
            child: Material(
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(25.sp),
              ),
              clipBehavior: Clip.hardEdge,
              child: SideMenuWidget(
                onTabChanged: (tab) {
                  setState(() {
                    _currentTab = tab.getHomePageEnum.index;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ColoredBox(
              color: context.isDesktop
                  ? Theme.of(context).colorScheme.outlineVariant
                  : Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  widget.header.call(
                    context,
                    HomePageEnum.values[_currentTab].title,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.sp, right: 10.sp),
                      child: Material(
                        shape: SuperellipseShape(
                          borderRadius: BorderRadius.circular(25.sp),
                        ),
                        clipBehavior: Clip.hardEdge,
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        child: IndexedStack(
                          index: _currentTab,
                          children: children,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
