import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/chats/presentation/widgets/avatar_chat.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';

class ChatCard extends StatefulWidget {
  final Room room;
  final EdgeInsetsGeometry? padding;
  const ChatCard({
    super.key,
    required this.room,
    this.padding,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Color? _background;

  Color get _defaultBackgroundColor => context.isDesktop
      ? Colors.transparent
      : Theme.of(context).scaffoldBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _background =
              Theme.of(context).colorScheme.primary.withValues(alpha: .1);
        });
      },
      onExit: (_) {
        setState(() {
          _background = null;
        });
      },
      child: Container(
        color: _background ?? _defaultBackgroundColor,
        padding: widget.padding ??
            EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 4.sp,
            ),
        child: Row(
          children: [
            AvatarChat(room: widget.room),
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
                              TextSpan(text: widget.room.title.trim()),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            widget.room.statusMessage == StatusMessage.none,
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
                                    widget.room.statusLastedMessage ==
                                            StatusSeenMessage.seen
                                        ? PhosphorIcons.checks()
                                        : PhosphorIcons.check(),
                                    color: widget.room.statusLastedMessage ==
                                            StatusSeenMessage.seen
                                        ? colorGreenLight
                                        : fCL,
                                    size: 12.sp,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.room.updateAtText,
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
                          widget.room.latestMessageData,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.sp),
                      widget.room.statusMessage == StatusMessage.none &&
                              widget.room.countUnreadMessage != 0
                          ? Container(
                              margin: widget.room.countUnreadMessage > 9
                                  ? EdgeInsets.symmetric(
                                      vertical: 3.sp,
                                    )
                                  : null,
                              padding: widget.room.countUnreadMessage > 9
                                  ? EdgeInsets.symmetric(
                                      horizontal: 3.sp,
                                      vertical: 2.sp,
                                    )
                                  : EdgeInsets.all(5.sp),
                              decoration: BoxDecoration(
                                shape: widget.room.countUnreadMessage > 9
                                    ? BoxShape.rectangle
                                    : BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: widget.room.countUnreadMessage > 9
                                    ? BorderRadius.circular(15.sp)
                                    : null,
                              ),
                              child: Text(
                                widget.room.countUnreadMessage > 9
                                    ? "+9"
                                    : widget.room.countUnreadMessage.toString(),
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
