import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:super_context_menu/super_context_menu.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/cached_network_image/cached_network_image.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/conversation/xmodels/default_avatar_model.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final Message? messagePrev;

  const MessageCard({super.key, required this.message, this.messagePrev});

  @override
  Widget build(BuildContext context) {
    final bool isDifferentSender =
        messagePrev?.createdBy?.id != message.createdBy?.id;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: isDifferentSender ? 12.sp : 4.sp,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isMe && isDifferentSender)
            CustomNetworkImage(
              height: 18.sp,
              width: 18.sp,
              urlToImage: message.createdBy?.avatar,
              defaultAvatar: message.createdBy == null
                  ? null
                  : DefaultAvatarModel.fromFullName(
                      message.createdBy!.fullName,
                    ),
            )
          else
            SizedBox(width: 18.sp),
          SizedBox(width: 5.sp),
          Column(
            crossAxisAlignment: message.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (isDifferentSender && !message.isMe)
                Padding(
                  padding: EdgeInsets.only(bottom: 2.sp),
                  child: Text(
                    message.createdBy?.fullName ?? "Unknown",
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: colorGray2,
                    ),
                  ),
                ),
              message.sendingStatus == SendingStatusEnum.sending
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
                  : message.sendingStatus == SendingStatusEnum.error
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
                                        MessageResent(
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
              ContextMenuWidget(
                menuProvider: (_) {
                  return _menuProvider();
                },
                child: _messageBody(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Material _messageBody(BuildContext context) {
    return Material(
      shape: SuperellipseShape(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.sp),
          topRight: Radius.circular(16.sp),
          bottomRight: messagePrev?.isMe == message.isMe
              ? Radius.circular(16.sp)
              : !message.isMe
                  ? Radius.zero
                  : Radius.circular(16.sp),
          bottomLeft: Radius.circular(16.sp),
        ),
        side: message.isDeleted
            ? BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? colorGray3
                    : colorGray2,
              )
            : BorderSide.none,
      ),
      color: message.isDeleted
          ? Colors.transparent
          : message.isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 6.sp,
        ),
        constraints: BoxConstraints(
          maxWidth: 195.sp,
        ),
        child: Text(
          message.dataX,
          style: TextStyle(
            color: message.isDeleted
                ? Theme.of(context).brightness == Brightness.dark
                    ? colorGray3
                    : colorGray2
                : message.isMe
                    ? Theme.of(context).colorScheme.surface
                    : null,
            fontSize: message.isDeleted ? 11.sp : 12.sp,
          ),
        ),
      ),
    );
  }

  Menu _menuProvider() {
    return Menu(
      children: List.generate(
        message.getOptions.length,
        (indexOptions) => MenuAction(
          image: MenuImage.icon(
            message.getOptions[indexOptions].iconData,
          ),
          attributes: MenuActionAttributes(
            destructive: message.getOptions[indexOptions].isDanger,
          ),
          title: message.getOptions[indexOptions].title,
          callback: () {
            message.getOptions[indexOptions].handlePressed?.call();
          },
        ),
      ),
    );
  }
}
