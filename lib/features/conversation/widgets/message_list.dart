import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/models/sending_status_enum.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/chats/presentation/widgets/bottom_chat_options.dart';
import 'package:waterbus/features/conversation/widgets/message_card.dart';
import 'package:waterbus/features/conversation/xmodels/message_model_x.dart';

class MessageList extends StatelessWidget {
  final List<MessageModel> messages;
  final ScrollController scrollController;
  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      semanticChildCount: messages.length,
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      reverse: true,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 12.sp),
          sliver: SuperSliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return GestureWrapper(
                  onLongPress: () {
                    if (messages[index].sendingStatus !=
                            SendingStatusEnum.sent ||
                        messages[index].isDeleted) return;

                    _handleLongPressMessageCard(
                      context,
                      messages[index],
                    );
                  },
                  child: MessageCard(
                    message: messages[index],
                    messagePrev: index < messages.length - 1
                        ? messages[index + 1]
                        : null,
                  ),
                );
              },
              childCount: messages.length,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLongPressMessageCard(
    BuildContext context,
    MessageModel messageModel,
  ) {
    if (!messageModel.isMe) return;

    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      enableDrag: false,
      builder: (context) {
        return BottomChatOptions(options: messageModel.getOptions);
      },
    );
  }
}
