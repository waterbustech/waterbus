// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';

// Project imports:
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class MeetView extends StatelessWidget {
  final EdgeInsets? margin;
  final ParticipantSFU participantSFU;
  final List<Participant> participants;
  final double avatarSize;
  final double? width;
  final BorderRadius? radius;
  final bool borderEnabled;
  const MeetView({
    super.key,
    required this.participantSFU,
    required this.participants,
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
      color: Theme.of(context).colorScheme.onInverseSurface,
      shape: SuperellipseShape(
        side: !borderEnabled || isScreenSharing
            ? BorderSide.none
            : BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: audioLevel == AudioLevel.kAudioStrong
                    ? 8.sp
                    : audioLevel == AudioLevel.kAudioLight
                        ? 6.sp
                        : 0.sp,
              ),
        borderRadius: radius ?? BorderRadius.circular(12.sp),
      ),
      child: SizedBox(
        width: width,
        child: Container(
          margin: margin,
          child: Stack(
            children: [
              videoRenderer?.srcObject != null && isVideoEnabled
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
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.5),
                            Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(.5),
                          ],
                          stops: const [0.1, 0.9],
                        ),
                      ),
                      child: AvatarCard(
                        urlToImage: participant.user.avatar,
                        size: avatarSize,
                      ),
                    ),
              if (kIsWeb)
                Positioned(
                  right: 10.sp,
                  bottom: 10.sp,
                  child: IconButton(
                    onPressed: () {
                      if (videoRenderer?.textureId == null) return;

                      WaterbusSdk.instance.setPiPEnabled(
                        textureId: videoRenderer!.textureId.toString(),
                      );
                    },
                    icon: Icon(
                      PhosphorIcons.picture_in_picture,
                      size: 18.sp,
                    ),
                  ),
                ),
              Positioned(
                left: 10.sp,
                bottom: 10.sp,
                child: Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  clipBehavior: Clip.hardEdge,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(.6),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.sp,
                      vertical: 8.sp,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          participant.user.fullName,
                          style: TextStyle(
                            color:
                                participant.isMe ? Colors.yellow : Colors.white,
                            fontSize: avatarSize / 6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Visibility(
                          visible: !hasFirstFrameRendered || !isAudioEnabled,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.sp),
                            child: !isAudioEnabled || isScreenSharing
                                ? Icon(
                                    isScreenSharing
                                        ? PhosphorIcons.screencast_bold
                                        : PhosphorIcons.microphone_slash_fill,
                                    color: isScreenSharing
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.redAccent,
                                    size: avatarSize / 5.25,
                                  )
                                : CupertinoActivityIndicator(
                                    radius: 6.5,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Participant get participant {
    if (participantSFU.ownerId == kIsMine) {
      return participants.firstWhere((participant) => participant.isMe);
    }

    return participants.firstWhere(
      (participant) => participant.id.toString() == participantSFU.ownerId,
    );
  }

  RTCVideoRenderer? get videoRenderer {
    if (participantSFU.isSharingScreen) {
      return participantSFU.screenShareRenderer;
    }

    return participantSFU.renderer;
  }

  bool get hasFirstFrameRendered {
    if (isScreenSharing) return true;

    return participantSFU.hasFirstFrameRendered;
  }

  bool get isVideoEnabled {
    if (participantSFU.isSharingScreen) return true;

    return participantSFU.isVideoEnabled;
  }

  bool get isAudioEnabled {
    if (participantSFU.isSharingScreen) return false;

    return participantSFU.isAudioEnabled;
  }

  bool get isScreenSharing {
    return participantSFU.isSharingScreen;
  }

  CameraType get cameraType {
    return participantSFU.cameraType;
  }

  AudioLevel get audioLevel {
    if (!isAudioEnabled) return AudioLevel.kSilence;

    return participantSFU.audioLevel;
  }
}
