// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';

// Project imports:
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  const MeetingCard({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.sp),
      padding: EdgeInsets.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meeting.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 4.sp),
          RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 11.sp),
              children: [
                TextSpan(text: Strings.roomCode.i18n),
                TextSpan(
                  text: meeting.code.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: meeting.isNoOneElse
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
              ),
              GestureDetector(
                onTap: () async {
                  await WaterbusPermissionHandler().checkGrantedForExecute(
                    permissions: [Permission.camera, Permission.microphone],
                    callBack: () async {
                      AppBloc.meetingBloc.add(
                        DisplayDialogMeetingEvent(meeting: meeting),
                      );
                    },
                  );
                },
                child: Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                      vertical: 7.sp,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 4.sp),
                        Text(
                          Strings.join.i18n,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 10.sp,
                                  ),
                        ),
                        SizedBox(width: 4.sp),
                        Icon(
                          PhosphorIcons.arrow_right_bold,
                          color: Colors.white,
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
