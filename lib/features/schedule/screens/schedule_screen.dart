// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/schedule/widgets/list_schedule.dart';
import 'package:waterbus/features/schedule/widgets/schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        "Schedule",
        titleTextSize: 16.sp,
        isVisibleBackButton: false,
        centerTitle: false,
        actions: [
          Icon(
            PhosphorIcons.dots_three_bold,
            color: Colors.white,
            size: 25.sp,
          ),
          SizedBox(width: 16.sp),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.sp),
            EnterCodeBox(
              hintTextContent: 'Find anything here',
              onTap: () {},
            ),
            SizedBox(height: 15.sp),
            const Schedule(),
            SizedBox(height: 20.sp),
            dividerContainer,
            SizedBox(height: 10.sp),
            const Expanded(
              child: ListSchedule(),
            ),
          ],
        ),
      ),
    );
  }
}
