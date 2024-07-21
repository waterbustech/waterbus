import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';

class ShimmerConversationList extends StatelessWidget {
  const ShimmerConversationList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: defaultLengthOfShimmerList,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const ShimmerChatCard(),
            Padding(
              padding: EdgeInsets.only(
                left: SizerUtil.isDesktop ? 74.sp : 66.sp,
              ),
              child: divider,
            ),
          ],
        );
      },
    );
  }
}
