// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/models/enums/audio_level.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class MeetView extends StatelessWidget {
  final EdgeInsets? margin;
  final Participant participant;
  final double avatarSize;
  final double? width;
  final CallState? callState;
  final BorderRadius? radius;
  final bool borderEnabled;
  const MeetView({
    super.key,
    required this.participant,
    required this.callState,
    this.avatarSize = 80.0,
    this.borderEnabled = true,
    this.margin,
    this.width,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.card,
      shape: SuperellipseShape(
        side: !borderEnabled
            ? BorderSide.none
            : BorderSide(
                color: Theme.of(context).primaryColor,
                width: audioLevel == AudioLevel.kAudioStrong
                    ? 8.sp
                    : audioLevel == AudioLevel.kAudioLight
                        ? 6.sp
                        : 4.sp,
              ),
        borderRadius: radius ?? BorderRadius.circular(18.sp),
      ),
      child: SizedBox(
        width: width,
        child: Container(
          margin: margin,
          child: Stack(
            children: [
              videoRenderer != null
                  ? RTCVideoView(
                      videoRenderer!,
                      key: videoRenderer!.textureId == null
                          ? null
                          : Key(videoRenderer!.textureId!.toString()),
                      objectFit: isScreenSharing || !borderEnabled
                          ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                          : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror:
                          !isScreenSharing && cameraType == CameraType.front,
                      filterQuality: FilterQuality.none,
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: AvatarCard(
                        urlToImage: participant.user.avatar,
                        size: avatarSize,
                      ),
                    ),
              Positioned(
                left: 10.sp,
                bottom: 10.sp,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.sp,
                    vertical: 8.sp,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.sp),
                    color: Colors.black.withOpacity(.3),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        participant.user.fullName,
                        style: TextStyle(
                          color: participant.role == MeetingRole.host
                              ? Colors.yellow
                              : participant.isMe
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                          fontSize: avatarSize / 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Visibility(
                        visible: !hasFirstFrameRendered || !isAudioEnabled,
                        child: Padding(
                          padding: EdgeInsets.only(left: 6.sp),
                          child: !isAudioEnabled
                              ? Icon(
                                  PhosphorIcons.microphone_slash_fill,
                                  color: Colors.redAccent,
                                  size: avatarSize / 5.25,
                                )
                              : CupertinoActivityIndicator(
                                  radius: 6.5,
                                  color: Theme.of(context).primaryColor,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RTCVideoRenderer? get videoRenderer {
    if ((!hasFirstFrameRendered || !isCameraEnabled) && !isScreenSharing) {
      return null;
    }

    if (participant.isMe) {
      return callState?.mParticipant?.renderer;
    } else {
      return callState?.participants[participant.id.toString()]?.renderer;
    }
  }

  bool get hasFirstFrameRendered {
    if (participant.isMe) {
      return callState?.mParticipant?.hasFirstFrameRendered ?? false;
    } else {
      return callState?.participants[participant.id.toString()]
              ?.hasFirstFrameRendered ??
          false;
    }
  }

  bool get isCameraEnabled {
    if (participant.isMe) {
      return callState?.mParticipant?.isVideoEnabled ?? false;
    } else {
      return callState
              ?.participants[participant.id.toString()]?.isVideoEnabled ??
          false;
    }
  }

  bool get isAudioEnabled {
    if (participant.isMe) {
      return callState?.mParticipant?.isAudioEnabled ?? false;
    } else {
      return callState
              ?.participants[participant.id.toString()]?.isAudioEnabled ??
          false;
    }
  }

  bool get isScreenSharing {
    if (participant.isMe) {
      return callState?.mParticipant?.isSharingScreen ?? false;
    } else {
      return callState
              ?.participants[participant.id.toString()]?.isSharingScreen ??
          false;
    }
  }

  CameraType get cameraType {
    if (participant.isMe) {
      return callState?.mParticipant?.cameraType ?? CameraType.front;
    } else {
      return callState?.participants[participant.id.toString()]?.cameraType ??
          CameraType.front;
    }
  }

  AudioLevel get audioLevel {
    if (!isAudioEnabled) return AudioLevel.kSilence;

    if (participant.isMe) {
      return callState?.mParticipant?.audioLevel ?? AudioLevel.kSilence;
    } else {
      return callState?.participants[participant.id.toString()]?.audioLevel ??
          AudioLevel.kSilence;
    }
  }
}
