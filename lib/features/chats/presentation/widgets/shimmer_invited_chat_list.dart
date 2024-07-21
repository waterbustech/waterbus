import 'package:flutter/cupertino.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/chats/presentation/widgets/shimmer_invited_chat_card.dart';
import 'package:waterbus/features/common/styles/style.dart';

class ShimmerInvitedChatList extends StatelessWidget {
  const ShimmerInvitedChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.sp),
      itemCount: defaultLengthOfShimmerList,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const ShimmerInvitedChatCard(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.sp)
                  .add(EdgeInsets.only(left: 58.sp)),
              child: divider,
            ),
          ],
        );
      },
    );
  }
}
