// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/home/widgets/dialog_prepare_meeting.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  const MeetingCard({
    super.key,
    required this.meeting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.sp),
      padding: EdgeInsets.symmetric(
        vertical: 14.sp,
        horizontal: 10.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meeting.title,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 8.sp),
          Row(
            children: [
              Expanded(
                child: StackAvatar(
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
                  showDialogWaterbus(
                    alignment: Alignment.bottomCenter,
                    paddingBottom: 56.sp,
                    child: const DialogPrepareMeeting(),
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
                      vertical: 8.sp,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 4.sp),
                        Text(
                          "Join",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 9.sp,
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
