import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/conversation/widgets/message_card.dart';

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
                return MessageCard(
                  message: messages[index],
                  messagePrev:
                      index < messages.length - 1 ? messages[index + 1] : null,
                );
              },
              childCount: messages.length,
            ),
          ),
        ),
      ],
    );
  }
}
