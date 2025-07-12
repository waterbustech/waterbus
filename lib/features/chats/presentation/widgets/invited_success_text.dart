import 'package:flutter/material.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

class InvitedSuccessText extends StatelessWidget {
  final Room room;
  final String fullname;

  const InvitedSuccessText({
    super.key,
    required this.room,
    required this.fullname,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(AppRouter.context!).textTheme.bodyMedium!.color,
          fontSize: 10.sp,
        ),
        children: [
          TextSpan(text: "${Strings.youHaveInvitedThe.i18n} "),
          TextSpan(
            text: fullname,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: " ${Strings.toJoinConversation.i18n} "),
          TextSpan(
            text: room.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
