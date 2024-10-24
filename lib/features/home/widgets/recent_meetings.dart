import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/date_titlle_card.dart';
import 'package:waterbus/features/home/widgets/e2ee_title_footer.dart';
import 'package:waterbus/features/home/widgets/empty_meet_view.dart';
import 'package:waterbus/features/home/widgets/meeting_card.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart';

class RecentMeetings extends StatelessWidget {
  const RecentMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentJoinedBloc, MeetingListState>(
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
                ContextMenuWidget(
                  menuProvider: (_) {
                    return _menuProvider(recentMeetings[index]);
                  },
                  child: MeetingCard(meeting: recentMeetings[index]),
                ),
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

  Menu _menuProvider(Meeting conversation) {
    return Menu(
      children: [
        MenuAction(
          image: MenuImage.icon(PhosphorIcons.trashSimple()),
          attributes: const MenuActionAttributes(destructive: true),
          title: Strings.delete.i18n,
          callback: () {
            AppBloc.recentJoinedBloc.add(
              RemoveRecentJoinedEvent(
                meetingId: conversation.id,
              ),
            );
          },
        ),
      ],
    );
  }
}
