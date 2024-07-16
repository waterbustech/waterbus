import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';

class ChatCard extends StatelessWidget {
  final Meeting meeting;
  const ChatCard({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            AvatarChat(meeting: meeting),
            Visibility(
              visible: !meeting.isGroup,
              child: Positioned(
                right: 6.sp,
                top: 2.sp,
                child: Container(
                  padding: EdgeInsets.all(1.2.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Container(
                    height: 7.sp,
                    width: 7.sp,
                    decoration: const BoxDecoration(
                      color: colorGreenLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 10.sp),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(text: meeting.title),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: meeting.statusMessage == StatusMessage.none,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          color: fCL,
                          fontSize: 10.sp,
                        ),
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.sp),
                              child: Icon(
                                meeting.statusLastedMessage ==
                                        StatusSeenMessage.seen
                                    ? PhosphorIcons.checks_bold
                                    : PhosphorIcons.check_bold,
                                color: meeting.statusLastedMessage ==
                                        StatusSeenMessage.seen
                                    ? colorGreenLight
                                    : fCL,
                                size: 12.sp,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('hh:mm')
                                .format(meeting.createdAt ?? DateTime.now()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.sp),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      meeting.latestMessage?.data ?? "Grounp created",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  meeting.statusMessage == StatusMessage.none &&
                          meeting.countUnreadMessage != 0
                      ? Container(
                          margin: meeting.countUnreadMessage > 9
                              ? EdgeInsets.symmetric(
                                  vertical: 3.sp,
                                )
                              : null,
                          padding: meeting.countUnreadMessage > 9
                              ? EdgeInsets.symmetric(
                                  horizontal: 3.sp,
                                  vertical: 2.sp,
                                )
                              : EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                            shape: meeting.countUnreadMessage > 9
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: meeting.countUnreadMessage > 9
                                ? BorderRadius.circular(15.sp)
                                : null,
                          ),
                          child: Text(
                            meeting.countUnreadMessage > 9
                                ? "+9"
                                : meeting.countUnreadMessage.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 19.sp,
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
