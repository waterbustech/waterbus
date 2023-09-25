// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';

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
                const TextSpan(text: 'Room code: '),
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
                child: meeting.users.length < 2
                    ? Text(
                        "No participants yet",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 11.sp),
                      )
                    : StackAvatar(
                        images: meeting.users
                            .map(
                              (user) => user.user.avatar,
                            )
                            .toList(),
                        size: 20.sp,
                      ),
              ),
              GestureDetector(
                onTap: () {
                  AppBloc.meetingBloc.add(
                    DisplayDialogMeetingEvent(meeting: meeting),
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
                          "Join",
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
