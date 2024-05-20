// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/message_model.dart';

class MessageCard extends StatelessWidget {
  final MessageModel message;
  final MessageModel? messagePrev;
  const MessageCard({
    super.key,
    required this.message,
    this.messagePrev,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(
        top: message.isMe == messagePrev?.isMe ? 4.sp : 12.sp,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          message.isMe || messagePrev?.isMe == message.isMe
              ? SizedBox(width: 18.sp)
              : CustomNetworkImage(
                  height: 18.sp,
                  width: 18.sp,
                  urlToImage: kUserDefault.avatar,
                ),
          SizedBox(width: 5.sp),
          Material(
            shape: SuperellipseShape(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp),
                bottomRight: messagePrev?.isMe == message.isMe
                    ? Radius.circular(20.sp)
                    : !message.isMe
                        ? Radius.zero
                        : Radius.circular(20.sp),
                bottomLeft: messagePrev?.isMe == message.isMe
                    ? Radius.circular(20.sp)
                    : message.isMe
                        ? Radius.zero
                        : Radius.circular(20.sp),
              ),
            ),
            color: message.isMe
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.sp,
                vertical: 10.sp,
              ),
              constraints: BoxConstraints(maxWidth: 65.w),
              child: Text(
                message.description,
                style: TextStyle(
                  color: message.isMe
                      ? Theme.of(context).colorScheme.surface
                      : null,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
