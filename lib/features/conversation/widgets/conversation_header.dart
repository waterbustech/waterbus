import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/chats/presentation/widgets/icon_button.dart';
import 'package:waterbus/features/conversation/widgets/bottom_sheet_add_member.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class ConversationHeader extends StatelessWidget {
  final Meeting meeting;
  const ConversationHeader({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        children: [
          Visibility(
            visible: AppNavigator.canPop,
            child: GestureWrapper(
              onTap: () {
                AppNavigator.pop();
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 12.sp).add(
                  EdgeInsets.only(right: 10.sp),
                ),
                child: Icon(
                  PhosphorIcons.caret_left_light,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureWrapper(
              onTap: () {
                AppNavigator().push(
                  Routes.detailGroupRoute,
                  arguments: {
                    "meeting": meeting,
                  },
                );
              },
              child: ColoredBox(
                color: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarChat(meeting: meeting, size: 30.sp),
                    SizedBox(width: 10.sp),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            meeting.title,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Text(
                            Strings.online.i18n,
                            style: TextStyle(
                              color: colorGreenLight,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 20.sp),
          IconButtonCustom(
            onTap: () {
              showDialogWaterbus(
                child: BottomSheetAddMember(code: meeting.code),
              );
            },
            icon: PhosphorIcons.user_circle_plus,
            sizeIcon: 22.sp,
            padding: EdgeInsets.all(3.sp),
            margin: EdgeInsets.zero,
          ),
          SizedBox(width: 10.sp),
          IconButtonCustom(
            onTap: () {
              AppBloc.meetingBloc.add(JoinMeetingEvent(meeting: meeting));
            },
            icon: PhosphorIcons.video_camera_light,
            sizeIcon: 22.sp,
            padding: EdgeInsets.all(3.sp),
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
