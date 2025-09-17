import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class SideFooterBody extends StatelessWidget {
  final AvatarCard userAvatar;
  final User user;

  const SideFooterBody({
    super.key,
    required this.userAvatar,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Row(
        spacing: 10.sp,
        children: [
          userAvatar,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '@${user.userName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 10.sp,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.sp),
          Icon(LucideIcons.chevronDown200),
        ],
      ),
    );
  }
}
