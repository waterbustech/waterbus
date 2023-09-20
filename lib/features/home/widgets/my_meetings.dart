// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/home/widgets/date_titlle_card.dart';
import 'package:waterbus/features/home/widgets/e2ee_title_footer.dart';
import 'package:waterbus/features/home/widgets/meeting_card.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';

class MyMeetings extends StatelessWidget {
  const MyMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state is! JoinedMeeting) return const SizedBox();

        final List<Meeting> recentMeetings = state.recentMeetings;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 80.sp),
          itemCount: recentMeetings.length,
          itemBuilder: (context, index) {
            // First or current created at not equal previous
            final bool hasLabelCreatedAt = index == 0 ||
                !DateTimeHelper().isEqualTwoDate(
                  recentMeetings[index - 1].createdAt,
                  recentMeetings[index].createdAt,
                );

            return Column(
              children: [
                hasLabelCreatedAt
                    ? DateTitleCard(
                        lastJoinedAt:
                            recentMeetings[index].createdAt ?? DateTime.now(),
                      )
                    : const SizedBox(),
                MeetingCard(meeting: recentMeetings[index]),
                index == recentMeetings.length - 1
                    ? const E2eeTitleFooter()
                    : const Divider(thickness: .3, height: .3),
              ],
            );
          },
        );
      },
    );
  }
}
