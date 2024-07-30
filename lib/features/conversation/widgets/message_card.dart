import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/utils/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';
import 'package:waterbus_sdk/types/models/message_status_enum.dart';

class MessageCard extends StatelessWidget {
  final MessageModel message;
  final MessageModel? messagePrev;

  const MessageCard({super.key, required this.message, this.messagePrev});

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
                  urlToImage: message.createdBy?.avatar,
                ),
          SizedBox(width: 5.sp),
          Column(
            crossAxisAlignment: message.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              message.status == MessageStatusEnum.sending
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 2.sp),
                      child: Text(
                        '${Strings.sending.i18n}...',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: colorGray2,
                        ),
                      ),
                    )
                  : message.status == MessageStatusEnum.error
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 3.sp),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style:
                                  TextStyle(fontSize: 8.sp, color: colorGray2),
                              children: [
                                TextSpan(
                                  text: "${Strings.canNotSend.i18n} ",
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      AppBloc.messageBloc.add(
                                        ResendMessageEvent(
                                          messageModel: message,
                                        ),
                                      );
                                    },
                                  text: Strings.resend.i18n,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
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
                    bottomLeft: Radius.circular(20.sp),
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
                  constraints: BoxConstraints(
                    maxWidth: SizerUtil.isDesktop ? 45.w : 195.sp,
                  ),
                  child: Text(
                    message.data,
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
        ],
      ),
    );
  }
}
