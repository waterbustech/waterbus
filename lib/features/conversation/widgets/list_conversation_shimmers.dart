import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/features/conversation/widgets/message_shimmer_card.dart';

class ListConversationShimmers extends StatelessWidget {
  const ListConversationShimmers({super.key});

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    bool isMe = random.nextBool();

    return ListView.builder(
      padding: EdgeInsets.only(top: 30.sp),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      itemCount: 20,
      itemBuilder: (context, index) {
        final int numberOfRow = random.nextInt(2) + 1;
        isMe = !isMe;

        return MessageShimmerCard(isMe: isMe, numberOfRow: numberOfRow);
      },
    );
  }
}
