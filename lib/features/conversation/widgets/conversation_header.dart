import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/chats/presentation/widgets/icon_button.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

class ConversationHeader extends StatelessWidget {
  const ConversationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (bf, at) {
        if (bf is ChatActived && at is ChatActived) {
          return bf.conversationCurrent != at.conversationCurrent;
        }

        return true;
      },
      builder: (context, state) {
        if (state is ChatActived) {
          final Room? room = state.conversationCurrent;

          return room == null
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
                                "meeting": room,
                              },
                            );
                          },
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AvatarChat(room: room, size: 30.sp),
                                SizedBox(width: 10.sp),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        room.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        "${room.members.length} ${(room.members.length < 2 ? Strings.member.i18n : Strings.members.i18n).toLowerCase()}",
                                        style: TextStyle(
                                          color: fCL,
                                          height: 0.75.sp,
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
                          AppBloc.roomBloc.add(RoomJoinedEvent(room: room));
                        },
                        icon: PhosphorIcons.broadcast(PhosphorIconsStyle.fill),
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
