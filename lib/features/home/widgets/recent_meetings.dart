import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/date_time_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/date_titlle_card.dart';
import 'package:waterbus/features/home/widgets/e2ee_title_footer.dart';
import 'package:waterbus/features/home/widgets/empty_meet_view.dart';
import 'package:waterbus/features/home/widgets/meeting_card.dart';
import 'package:waterbus/features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

class RecentMeetings extends StatelessWidget {
  const RecentMeetings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentJoinedBloc, RecentJoinedState>(
      builder: (context, state) {
        if (state is RoomInitial) return const SizedBox();

        final List<Room> recentRooms = state.recentRooms;

        if (recentRooms.isEmpty) {
          return const EmptyMeetView();
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(bottom: 80.sp),
          itemCount: recentRooms.length,
          itemBuilder: (context, index) {
            // First or current created at not equal previous
            final bool hasLabelCreatedAt = index == 0 ||
                !DateTimeUtils().isEqualTwoDate(
                  recentRooms[index - 1].latestJoinedTime,
                  recentRooms[index].latestJoinedTime,
                );

            return Column(
              children: [
                hasLabelCreatedAt
                    ? DateTitleCard(
                        lastJoinedAt: recentRooms[index].latestJoinedTime,
                      )
                    : const SizedBox(),
                ContextMenuWidget(
                  menuProvider: (_) {
                    return _menuProvider(recentRooms[index]);
                  },
                  child: MeetingCard(room: recentRooms[index]),
                ),
                index == recentRooms.length - 1
                    ? const E2eeTitleFooter()
                    : const Divider(thickness: .3, height: .3),
              ],
            );
          },
        );
      },
    );
  }

  Menu _menuProvider(Room conversation) {
    return Menu(
      children: [
        MenuAction(
          image: MenuImage.icon(PhosphorIcons.trashSimple()),
          attributes: const MenuActionAttributes(destructive: true),
          title: Strings.delete.i18n,
          callback: () {
            AppBloc.recentJoinedBloc.add(
              RecentJoinedRemoved(
                roomId: conversation.id,
              ),
            );
          },
        ),
      ],
    );
  }
}
