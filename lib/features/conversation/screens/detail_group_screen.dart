import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_sheet_delete.dart';
import 'package:waterbus_sdk/types/models/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/conversation/widgets/add_member_button.dart';
import 'package:waterbus/features/conversation/widgets/detail_group_button.dart';
import 'package:waterbus/features/conversation/widgets/group_space_bar_custom.dart';
import 'package:waterbus/features/conversation/widgets/member_card.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class DetailGroupScreen extends StatelessWidget {
  final Meeting meeting;
  const DetailGroupScreen({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 155.sp,
            actions: [
              Tooltip(
                message: Strings.leaveTheConversation.i18n,
                child: GestureWrapper(
                  onTap: () {
                    AppBloc.chatBloc
                        .add(DeleteOrLeaveConversationEvent(meeting: meeting));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 16.sp),
                    child: Icon(
                      PhosphorIcons.sign_out,
                      size: 20.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ],
            leading: GestureWrapper(
              onTap: () {
                AppNavigator.pop();
              },
              child: Tooltip(
                message: Strings.back.i18n,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 3.sp),
                  child: Icon(
                    PhosphorIcons.caret_left_light,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            flexibleSpace: GroupSpaceBarCustom(
              avatar: AvatarChat(
                meeting: meeting,
                size: 54.sp,
              ),
              subTitle: Text(
                "${meeting.members.length} ${(meeting.members.length < 2 ? Strings.member.i18n : Strings.members.i18n).toLowerCase()}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.sp, color: fCL),
              ),
              title: Text(
                meeting.title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.sp),
                  height: 48.sp,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DetailGroupButton(
                          onTap: () {
                            AppBloc.meetingBloc
                                .add(JoinMeetingEvent(meeting: meeting));
                          },
                          icon: PhosphorIcons.video_camera_fill,
                          title: Strings.videoCall.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.bell_ringing_fill,
                          title: Strings.mute.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.magnifying_glass_bold,
                          title: Strings.search.i18n,
                        ),
                        DetailGroupButton(
                          icon: PhosphorIcons.dots_three_outline_fill,
                          title: Strings.more.i18n,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ActiveChatState) {
                final Meeting conversation =
                    state.conversations.firstWhereOrNull(
                          (conversation) => conversation.id == meeting.id,
                        ) ??
                        meeting;

                conversation.members
                    .sort((a, b) => a.user.id == meeting.host?.id ? -1 : 1);

                final int numberOfWidgetsAdded = meeting.isHost ? 1 : 0;
                final int widgetLength =
                    conversation.members.length + numberOfWidgetsAdded;

                return SliverPadding(
                  padding: EdgeInsets.only(bottom: 30.sp),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bool isHost = index > 0 &&
                            conversation.host?.id ==
                                conversation
                                    .members[index - numberOfWidgetsAdded]
                                    .user
                                    .id;

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.sp),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                index == 0 ? 12.sp : 0,
                              ),
                              bottom: Radius.circular(
                                index == widgetLength - 1 ? 12.sp : 0,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                index == widgetLength - 1 ? 12.sp : 0,
                              ),
                            ), // Bo góc nếu cần
                            child: Slidable(
                              key: ValueKey(conversation.id),
                              enabled: index != 0 && !isHost,
                              endActionPane: ActionPane(
                                extentRatio: 0.3,
                                motion: const StretchMotion(),
                                dragDismissible: false,
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await showModalBottomSheet(
                                        context: AppNavigator.context!,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        barrierColor: Colors.black38,
                                        enableDrag: false,
                                        builder: (context) {
                                          return BottomSheetDelete(
                                            actionText:
                                                Strings.deleteMember.i18n,
                                            description:
                                                Strings.sureDeleteMember.i18n,
                                            handlePressed: () async {
                                              AppBloc.chatBloc.add(
                                                DeleteMemberEvent(
                                                  code: conversation.code,
                                                  userId: conversation
                                                      .members[index -
                                                          numberOfWidgetsAdded]
                                                      .id,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    backgroundColor: colorHigh,
                                    foregroundColor: mCL,
                                    icon: PhosphorIcons.trash,
                                    label: Strings.delete.i18n,
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: 4.sp,
                                  bottom: index == widgetLength - 1 ? 4.sp : 0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    index == 0 && conversation.isHost
                                        ? AddMemberButton(
                                            conversation: conversation,
                                          )
                                        : MemberCard(
                                            member: conversation.members[
                                                index - numberOfWidgetsAdded],
                                            isHost: isHost,
                                          ),
                                    if (index != widgetLength - 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 4.sp,
                                          left: 50.sp,
                                        ),
                                        child: const Divider(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: widgetLength,
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
