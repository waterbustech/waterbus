import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';

class ConversationLabel extends StatelessWidget {
  const ConversationLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Strings.chat.i18n,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 15.sp,
                ),
          ),
          GestureWrapper(
            onTap: () {
              AppNavigator().push(Routes.invitedRoute);
            },
            child: Material(
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(10.sp),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 5.sp),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.paperPlaneTilt(),
                      size: 12.sp,
                    ),
                    SizedBox(width: 6.sp),
                    Text(
                      "Invite",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
