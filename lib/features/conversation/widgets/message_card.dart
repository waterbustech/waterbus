// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/message_model.dart';

class MessageCard extends StatelessWidget {
  final MessageModel messageModel;
  final MessageModel? messageModelBefore;
  const MessageCard({
    super.key,
    required this.messageModel,
    this.messageModelBefore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      margin: EdgeInsets.only(
        bottom: messageModelBefore?.isMe == messageModel.isMe ? 5.sp : 16.sp,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            messageModel.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          messageModel.isMe || messageModelBefore?.isMe == messageModel.isMe
              ? SizedBox(
                  width: 18.sp,
                )
              : CustomNetworkImage(
                  height: 18.sp,
                  width: 18.sp,
                  urlToImage:
                      'https://plus.unsplash.com/premium_photo-1667810132017-c40be88c6b25?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fG1vZGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=900&q=60',
                ),
          SizedBox(width: 5.sp),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15.sp,
              vertical: 10.sp,
            ),
            decoration: BoxDecoration(
              color: messageModel.isMe ? colorPrimary : colorDarkGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.sp),
                topRight: Radius.circular(10.sp),
                bottomRight: messageModelBefore?.isMe == messageModel.isMe
                    ? Radius.circular(10.sp)
                    : messageModel.isMe
                        ? Radius.zero
                        : Radius.circular(10.sp),
                bottomLeft: messageModelBefore?.isMe == messageModel.isMe
                    ? Radius.circular(10.sp)
                    : !messageModel.isMe
                        ? Radius.zero
                        : Radius.circular(10.sp),
              ),
            ),
            constraints: BoxConstraints(maxWidth: 65.w),
            child: Text(
              messageModel.description,
              style: TextStyle(color: mCL, fontSize: 12.sp),
            ),
          )
        ],
      ),
    );
  }
}
