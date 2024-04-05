// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/home/widgets/date_titlle_card.dart';
import 'package:waterbus/features/home/widgets/e2ee_title_footer.dart';
import 'package:waterbus/features/home/widgets/empty_meet_view.dart';
import 'package:waterbus/features/home/widgets/meeting_card.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_list/bloc/meeting_list_bloc.dart';

class RecentMeetings extends StatelessWidget {
  const RecentMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingListBloc, MeetingListState>(
      builder: (context, state) {
        if (state is MeetingInitial) return const SizedBox();

        final List<Meeting> recentMeetings = state.recentMeetings;

        if (recentMeetings.isEmpty) {
          return const EmptyMeetView();
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 80.sp),
          itemCount: recentMeetings.length,
          itemBuilder: (context, index) {
            // First or current created at not equal previous
            final bool hasLabelCreatedAt = index == 0 ||
                !DateTimeHelper().isEqualTwoDate(
                  recentMeetings[index - 1].latestJoinedTime,
                  recentMeetings[index].latestJoinedTime,
                );

            return Column(
              children: [
                hasLabelCreatedAt
                    ? DateTitleCard(
                        lastJoinedAt: recentMeetings[index].latestJoinedTime,
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
