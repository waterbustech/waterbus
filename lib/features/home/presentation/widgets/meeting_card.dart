import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/clipboard_utils.dart';
import 'package:waterbus/core/utils/permission_handler.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/home/presentation/widgets/stack_avatar.dart';
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
          SizedBox(height: 8.sp),
          Wrap(
            spacing: 4.sp,
            children: [
              _buildTag(
                context,
                label: 'Protocol: ${room.streamingProtocol.name.toUpperCase()}',
                color: _getColorByProtocol(room.streamingProtocol),
              ),
              _buildTag(
                context,
                label:
                    'Capacity: ${room.capacity == null ? 'Unlimited' : room.capacity.toString()}',
                color: Colors.cyanAccent,
              ),
            ],
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
                      AppBloc.roomBloc.add(RoomInfoGot(room: room));
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: .1),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: .2),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.join.i18n.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  letterSpacing: 1.1,
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        LucideIcons.arrowRight,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 10.sp,
            width: 10.sp,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.sp),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 11.sp, color: color),
          ),
        ],
      ),
    );
  }

  Color _getColorByProtocol(StreamingProtocol protocol) {
    return switch (protocol) {
      StreamingProtocol.sfu => Colors.orangeAccent,
      StreamingProtocol.hls => Colors.purpleAccent,
    };
  }
}
