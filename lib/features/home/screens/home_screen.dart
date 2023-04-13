// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/home/widgets/enter_code_box.dart';
import 'package:waterbus/features/home/widgets/home_header.dart';
import 'package:waterbus/features/home/widgets/invitation_list.dart';
import 'package:waterbus/features/home/widgets/my_meetings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HomeHeader(),
            SizedBox(height: 16.sp),
            EnterCodeBox(
              onTap: () {
                AppNavigator.push(Routes.enterCodeRoute);
              },
            ),
            SizedBox(height: 16.sp),
            const Divider(thickness: .3, height: .3),
            SizedBox(height: 10.sp),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    InvitationList(),
                    MyMeetings(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
