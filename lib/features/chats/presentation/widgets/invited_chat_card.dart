import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/invited_chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/common/styles/style.dart';

class InvitedChatCard extends StatelessWidget {
  final Meeting invitedConversation;
  final int index;
  const InvitedChatCard({
    super.key,
    required this.invitedConversation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp).add(
            EdgeInsets.only(top: index == 0 ? 10.sp : 0),
          ),
          child: Row(
            children: [
              AvatarChat(
                meeting: invitedConversation,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.sp,
                  ),
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 11.sp,
                        height: 1.sp,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                      children: [
                        TextSpan(
                          text: "${Strings.youHaveBeenInvitedToChat.i18n} ",
                        ),
                        TextSpan(
                          text: "${invitedConversation.title}.",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureWrapper(
                onTap: () {
                  AppBloc.invitedChatBloc.add(
                    AcceptInviteEvent(
                      meetingId: invitedConversation.id,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.sp,
                    vertical: 2.sp,
                  ),
                  decoration: ShapeDecoration(
                    shape: SuperellipseShape(
                      side: BorderSide(
                        width: 1.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8.sp),
                    ),
                  ),
                  child: Text(
                    Strings.confirm.i18n.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 8.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.sp)
              .add(EdgeInsets.only(left: 54.sp)),
          child: divider,
        ),
      ],
    );
  }
}
