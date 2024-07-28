import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/index.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum_x.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final bool isHost;
  const MemberCard({
    super.key,
    required this.member,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.sp,
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Row(
        children: [
          AvatarCard(
            urlToImage: member.user.avatar,
            size: 30.sp,
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.user.fullName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.status.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 10.5.sp,
                  ),
                ),
              ],
            ),
          ),
          isHost
              ? Text(
                  Strings.owner.i18n.toLowerCase(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 10.5.sp,
                        color: fCL,
                      ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
