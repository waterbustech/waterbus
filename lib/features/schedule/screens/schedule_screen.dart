// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/home/widgets/search_box.dart';
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
      appBar: AppBar(
        title: Text(
          'Schedule',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          Icon(
            PhosphorIcons.dots_three_bold,
            color: Colors.white,
            size: 25.sp,
          ),
          SizedBox(width: 16.sp),
        ],
        backgroundColor: colorPrimaryBlack,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.sp),
            const SearchBox(
              hintText: 'Find anything here',
            ),
            SizedBox(height: 15.sp),
            const Schedule(),
            SizedBox(height: 20.sp),
            dividerContainer,
            SizedBox(height: 10.sp),
            const Expanded(child: ListSchedule()),
          ],
        ),
      ),
    );
  }
}
