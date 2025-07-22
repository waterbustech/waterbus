import 'package:flutter/material.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/home/widgets/side_menu_widget.dart';
import 'package:waterbus/features/home/xmodels/home_page_enum.dart';

class HomeDesktopScreen extends StatefulWidget {
  final Widget Function(BuildContext, String) header;
  const HomeDesktopScreen({
    super.key,
    required this.header,
  });

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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1600),
          child: Row(
            children: [
              SideMenuWidget(
                onTabChanged: (tab) {
                  setState(() {
                    _currentTab = tab.getHomePageEnum.index;
                  });
                },
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 54.sp,
                      padding: EdgeInsetsGeometry.only(left: 16.sp),
                      child: Row(
                        spacing: 60.sp,
                        children: [
                          Text(
                            HomePageEnum.values[_currentTab].title.i18n,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: widget.header.call(
                              context,
                              HomePageEnum.values[_currentTab].title,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    Expanded(
                      child: IndexedStack(
                        index: _currentTab,
                        children: children,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
