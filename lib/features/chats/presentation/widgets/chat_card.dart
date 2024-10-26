import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';

class ChatCard extends StatefulWidget {
  final Meeting meeting;
  const ChatCard({super.key, required this.meeting});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Color _background = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _background = Theme.of(context).colorScheme.primary.withOpacity(.1);
        });
      },
      onExit: (_) {
        setState(() {
          _background = Colors.transparent;
        });
      },
      child: Container(
        color: _background,
        padding: EdgeInsets.symmetric(
          horizontal: 16.sp,
          vertical: 4.sp,
        ),
        child: Row(
          children: [
            AvatarChat(meeting: widget.meeting),
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
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(text: widget.meeting.title.trim()),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            widget.meeting.statusMessage == StatusMessage.none,
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
                                    widget.meeting.statusLastedMessage ==
                                            StatusSeenMessage.seen
                                        ? PhosphorIcons.checks()
                                        : PhosphorIcons.check(),
                                    color: widget.meeting.statusLastedMessage ==
                                            StatusSeenMessage.seen
                                        ? colorGreenLight
                                        : fCL,
                                    size: 12.sp,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.meeting.updateAtText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.sp),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.meeting.latestMessageData,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      widget.meeting.statusMessage == StatusMessage.none &&
                              widget.meeting.countUnreadMessage != 0
                          ? Container(
                              margin: widget.meeting.countUnreadMessage > 9
                                  ? EdgeInsets.symmetric(
                                      vertical: 3.sp,
                                    )
                                  : null,
                              padding: widget.meeting.countUnreadMessage > 9
                                  ? EdgeInsets.symmetric(
                                      horizontal: 3.sp,
                                      vertical: 2.sp,
                                    )
                                  : EdgeInsets.all(5.sp),
                              decoration: BoxDecoration(
                                shape: widget.meeting.countUnreadMessage > 9
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius:
                                    widget.meeting.countUnreadMessage > 9
                                        ? BorderRadius.circular(15.sp)
                                        : null,
                              ),
                              child: Text(
                                widget.meeting.countUnreadMessage > 9
                                    ? "+9"
                                    : widget.meeting.countUnreadMessage
                                        .toString(),
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
        ),
      ),
    );
  }
}
