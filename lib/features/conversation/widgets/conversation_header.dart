// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/widgets/avatar_chat.dart';
import 'package:waterbus/features/chats/widgets/icon_button.dart';
import 'package:waterbus/features/chats/xmodels/chat_model.dart';

class ConversationHeader extends StatelessWidget {
  final ChatModel chatModel;
  const ConversationHeader({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
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
                  PhosphorIcons.caret_left_light,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          AvatarChat(chatModel: chatModel, size: 30.sp),
          SizedBox(width: 10.sp),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chatModel.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    Strings.online.i18n,
                    style: TextStyle(
                      color: colorGreenLight,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButtonCustom(
            icon: PhosphorIcons.video_camera_light,
            sizeIcon: 22.sp,
            padding: EdgeInsets.all(3.sp),
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
