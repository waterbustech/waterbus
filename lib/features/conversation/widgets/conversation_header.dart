import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/meeting_model.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/chats/presentation/widgets/icon_button.dart';
import 'package:waterbus/features/conversation/widgets/bottom_sheet_add_member.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class ConversationHeader extends StatelessWidget {
  const ConversationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (bf, at) {
        if (bf is ActiveChatState && at is ActiveChatState) {
          return bf.conversationCurrent != at.conversationCurrent;
        }

        return true;
      },
      builder: (context, state) {
        if (state is ActiveChatState) {
          final Meeting? meeting = state.conversationCurrent;

          return meeting == null
              ? const SizedBox()
              : Container(
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
                              PhosphorIcons.caretLeft(PhosphorIconsStyle.light),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        meeting.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        "${meeting.members.length} ${(meeting.members.length < 2 ? Strings.member.i18n : Strings.members.i18n).toLowerCase()}",
                                        style: TextStyle(
                                          color: fCL,
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
                      Visibility(
                        visible: meeting.isHost,
                        child: IconButtonCustom(
                          onTap: () {
                            showDialogWaterbus(
                              child: BottomSheetAddMember(
                                code: meeting.code,
                                meetingId: meeting.id,
                              ),
                            );
                          },
                          icon: PhosphorIcons.userCirclePlus(),
                          sizeIcon: 22.sp,
                          padding: EdgeInsets.all(3.sp),
                          margin: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      IconButtonCustom(
                        onTap: () {
                          AppBloc.meetingBloc
                              .add(JoinMeetingEvent(meeting: meeting));
                        },
                        icon:
                            PhosphorIcons.videoCamera(PhosphorIconsStyle.light),
                        sizeIcon: 22.sp,
                        padding: EdgeInsets.all(3.sp),
                        margin: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
        }

        return const SizedBox();
      },
    );
  }
}
