// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/home/widgets/date_titlle_card.dart';
import 'package:waterbus/features/home/widgets/e2ee_title_footer.dart';
import 'package:waterbus/features/home/widgets/meeting_card.dart';

class MyMeetings extends StatelessWidget {
  const MyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Text(
              "My Meetings",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          SizedBox(height: 10.sp),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 80.sp),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    index.isEven
                        ? DateTitleCard(
                            lastJoinedAt: DateTime.now().subtract(
                              Duration(days: index),
                            ),
                          )
                        : const SizedBox(),
                    const MeetingCard(),
                    index >= 2
                        ? const E2eeTitleFooter()
                        : const Divider(thickness: .3, height: .3)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
