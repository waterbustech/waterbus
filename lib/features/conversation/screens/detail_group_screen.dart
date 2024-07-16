import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus_sdk/types/models/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/conversation/widgets/bottom_sheet_add_member.dart';
import 'package:waterbus/features/conversation/widgets/detail_group_button.dart';
import 'package:waterbus/features/conversation/widgets/group_space_bar_custom.dart';
import 'package:waterbus/features/conversation/widgets/member_card.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';
import 'package:waterbus/gen/assets.gen.dart';

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
            leading: GestureWrapper(
              onTap: () {
                AppNavigator.pop();
              },
              child: Tooltip(
                message: 'Back',
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
                "${meeting.members.length} ${meeting.members.length < 2 ? "member" : "members"}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.sp, color: fCL),
              ),
              title: Text(
                meeting.host?.fullName ?? "",
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                meeting.members
                    .sort((a, b) => a.user.id == meeting.host?.id ? -1 : 1);

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.sp),
                  padding: EdgeInsets.only(
                    top: index == 0 ? 4.sp : 0,
                    bottom: index == meeting.members.length ? 4.sp : 0,
                  ),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    shape: SuperellipseShape(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(index == 0 ? 30.sp : 0),
                        bottom: Radius.circular(
                          index == meeting.members.length ? 30.sp : 0,
                        ),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      index == 0
                          ? GestureWrapper(
                              onTap: () {
                                showDialogWaterbus(
                                  child: BottomSheetAddMember(
                                    code: meeting.code,
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.sp,
                                  vertical: 2.sp,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: 30.sp,
                                      child: Image.asset(
                                        Assets.icons.icAddMembers.path,
                                        width: 24.sp,
                                        height: 26.sp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    SizedBox(width: 8.sp),
                                    Text(
                                      Strings.addMembers.i18n,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 12.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : MemberCard(
                              user: meeting.members[index - 1].user,
                              isHost: meeting.host?.id ==
                                  meeting.members[index - 1].user.id,
                            ),
                      if (index != meeting.members.length)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 4.sp,
                            bottom: 4.sp,
                            left: 50.sp,
                          ),
                          child: const Divider(),
                        ),
                    ],
                  ),
                );
              },
              childCount: meeting.members.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
