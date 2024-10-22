import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:popover/popover.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/footer_popover_body.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class SideFooterBody extends StatelessWidget {
  final AvatarCard userAvatar;
  final User user;

  const SideFooterBody({
    super.key,
    required this.userAvatar,
    required this.user,
  });

  Future<Object?> _handleShowInformationOptions(BuildContext context) {
    return showPopover(
      routeSettings: const RouteSettings(name: Routes.dialogRoute),
      context: context,
      bodyBuilder: (context) => const FooterPopoverBody(),
      width: 200.sp,
      radius: 12.sp,
      barrierColor: Colors.black38,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      arrowHeight: 10.sp,
      arrowWidth: 16.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureWrapper(
      onTap: () {
        _handleShowInformationOptions(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 8.sp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.sp),
          border: Border.all(
            width: 1.sp,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
        child: Row(
          children: [
            userAvatar,
            SizedBox(width: 6.sp),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Icon(PhosphorIcons.dotsThree()),
            ),
          ],
        ),
      ),
    );
  }
}
