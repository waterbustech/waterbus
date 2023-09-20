// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';

class EnterMeetingCode extends StatefulWidget {
  const EnterMeetingCode({super.key});

  @override
  State<StatefulWidget> createState() => _EnterMeetingCardState();
}

class _EnterMeetingCardState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Join a meeting',
        actions: [
          GestureWrapper(
            onTap: () {
              AppNavigator.pop();
              AppNavigator.push(Routes.meetingRoute);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.sp,
                vertical: 12.sp,
              ),
              color: Colors.transparent,
              alignment: Alignment.bottomRight,
              child: Text(
                'Join',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Column(
          children: [
            SizedBox(height: 12.sp),
            Text(
              "Enter a meeting code to request join the meeting and you need to wait for host accepted to started the meet",
              textAlign: TextAlign.justify,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 12.sp,
                  ),
            ),
            SizedBox(height: 24.sp),
            EnterCodeBox(
              margin: EdgeInsets.zero,
              contentPadding: EdgeInsets.only(
                left: 16.sp,
                right: 10.sp,
              ),
              hintTextContent: "Example: 12345678",
            ),
          ],
        ),
      ),
    );
  }
}
