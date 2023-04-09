import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/home/widgets/home_header.dart';
import 'package:waterbus/features/home/widgets/my_meetings.dart';
import 'package:waterbus/features/home/widgets/search_box.dart';

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
        child: Column(
          children: [
            const HomeHeader(),
            SizedBox(height: 24.sp),
            const SearchBox(),
            const MyMeetings(),
          ],
        ),
      ),
    );
  }
}
