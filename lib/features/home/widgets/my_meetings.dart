// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/home/widgets/meeting_card.dart';

class MyMeetings extends StatelessWidget {
  const MyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 14.sp),
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Meetings",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 10.sp),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 40.sp),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return const MeetingCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
