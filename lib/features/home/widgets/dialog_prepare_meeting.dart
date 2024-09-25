import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/share_utils.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/home/widgets/time_card.dart';
import 'package:waterbus/features/meeting/presentation/widgets/preview_camera_card.dart';

class DialogPrepareMeeting extends StatelessWidget {
  final Meeting meeting;
  final Function() handleJoinMeeting;
  const DialogPrepareMeeting({
    super.key,
    required this.meeting,
    required this.handleJoinMeeting,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PreviewCameraCard(),
              SizedBox(height: 16.sp),
              meeting.isNoOneElse
                  ? Text(
                      Strings.noParticipantsYet.i18n,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 11.sp),
                    )
                  : StackAvatar(
                      images: meeting.members
                          .map(
                            (user) => user.user.avatar,
                          )
                          .toList(),
                      size: 20.sp,
                    ),
              SizedBox(height: 16.sp),
              Text(
                meeting.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeCard(
                    text: DateFormat('MMMM dd', 'en_US')
                        .format(meeting.latestJoinedTime),
                    iconData: PhosphorIcons.clock(),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                  ),
                  SizedBox(width: 4.sp),
                  GestureWrapper(
                    onTap: () async {
                      await ShareUtils().share(
                        link: meeting.inviteLink,
                        description: meeting.title,
                      );
                    },
                    child: TimeCard(
                      text: Strings.shareLink.i18n,
                      iconData: PhosphorIcons.export(),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.sp),
              GestureWrapper(
                onTap: handleJoinMeeting,
                child: Material(
                  clipBehavior: Clip.hardEdge,
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  color: Theme.of(context).colorScheme.surfaceTint,
                  child: Container(
                    width: 80.sp,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                      vertical: 8.sp,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 4.sp),
                        Text(
                          Strings.start.i18n,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 9.sp,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                        SizedBox(width: 4.sp),
                        Icon(
                          PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                          color: Theme.of(context).colorScheme.surface,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.sp),
            ],
          ),
        ),
      ],
    );
  }
}
