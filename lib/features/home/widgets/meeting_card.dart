import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/clipboard_utils.dart';
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';

class MeetingCard extends StatelessWidget {
  final Room room;
  const MeetingCard({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.isDesktop
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(10.sp).add(
        EdgeInsets.only(bottom: 4.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room.title,
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
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      ClipboardUtils.copyMeetLink(room.code.toString());
                    },
                  text: room.code.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: room.isNoOneElse
                    ? Text(
                        Strings.noParticipantsYet.i18n,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontSize: 11.sp),
                      )
                    : StackAvatar(
                        label: room.members
                            .map(
                              (user) => user.user.fullName,
                            )
                            .toList(),
                        images: room.members
                            .map(
                              (user) => user.user.avatar,
                            )
                            .toList(),
                        size: 20.sp,
                      ),
              ),
              GestureWrapper(
                onTap: () async {
                  await WaterbusPermissionHandler().checkGrantedForExecute(
                    permissions: [Permission.camera, Permission.microphone],
                    callBack: () async {
                      AppBloc.roomBloc.add(RoomDialogDisplayed(room: room));
                    },
                  );
                },
                child: Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(25.sp),
                  ),
                  color: Theme.of(context).colorScheme.surfaceTint,
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 10.sp,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                        SizedBox(width: 4.sp),
                        Icon(
                          PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
                          size: 12.sp,
                          color: Theme.of(context).colorScheme.surface,
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
