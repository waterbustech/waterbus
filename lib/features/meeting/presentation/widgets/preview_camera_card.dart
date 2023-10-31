// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class PreviewCameraCard extends StatelessWidget {
  const PreviewCameraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        final ParticipantSFU? participant = state.callState?.mParticipant;

        // Return skeleton
        if (participant == null) {
          return Material(
            clipBehavior: Clip.hardEdge,
            shape: SuperellipseShape(
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Container(
              width: 265.sp,
              height: 200.sp,
              color: Colors.black,
            ),
          );
        }

        return Stack(
          children: [
            Material(
              clipBehavior: Clip.hardEdge,
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(30.sp),
              ),
              child: Container(
                width: 265.sp,
                height: 200.sp,
                color: Colors.black,
                child: participant.isVideoEnabled
                    ? RTCVideoView(
                        participant.renderer!,
                        key: participant.renderer!.textureId == null
                            ? null
                            : Key(participant.renderer!.textureId!.toString()),
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        mirror: true,
                        filterQuality: FilterQuality.none,
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: AvatarCard(
                          urlToImage: AppBloc.userBloc.user?.avatar,
                          size: 50.sp,
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 10.sp,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CallActionButton(
                    icon: participant.isVideoEnabled
                        ? PhosphorIcons.camera
                        : PhosphorIcons.camera_slash,
                    onTap: () {
                      AppBloc.meetingBloc.add(ToggleVideoEvent());
                    },
                  ),
                  SizedBox(width: 12.sp),
                  CallActionButton(
                    icon: participant.isAudioEnabled
                        ? PhosphorIcons.microphone
                        : PhosphorIcons.microphone_slash,
                    onTap: () {
                      AppBloc.meetingBloc.add(ToggleAudioEvent());
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
