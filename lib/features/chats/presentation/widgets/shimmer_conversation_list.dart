import 'package:flutter/material.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';

class ShimmerConversationList extends StatelessWidget {
  const ShimmerConversationList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: defaultLengthOfShimmerList,
      itemBuilder: (context, index) {
        return const ShimmerChatCard();
      },
    );
  }
}
