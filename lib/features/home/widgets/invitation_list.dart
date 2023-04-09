// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/features/home/widgets/invitation_card.dart';

class InvitationList extends StatelessWidget {
  const InvitationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invitations",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 10.sp),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: 1,
            itemBuilder: (context, index) {
              return const InvitationCard();
            },
          ),
        ],
      ),
    );
  }
}
