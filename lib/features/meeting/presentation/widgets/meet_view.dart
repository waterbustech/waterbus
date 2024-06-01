import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/types/enums/audio_level.dart';

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
        side: !borderEnabled || _isScreenSharing
            ? BorderSide.none
            : BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: _audioLevel == AudioLevel.kAudioStrong
                    ? 8.sp
                    : _audioLevel == AudioLevel.kAudioLight
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
              _shoundDisplayVideoRenderer
                  ? _mediaSource!.mediaView(
                      objectFit: _isScreenSharing || !borderEnabled
                          ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                          : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror:
                          !_isScreenSharing && _cameraType == CameraType.front,
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
                                .surfaceContainerHighest
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
                      if (participantSFU.cameraSource?.textureId == null) {
                        return;
                      }

                      WaterbusSdk.instance.setPiPEnabled(
                        textureId:
                            participantSFU.cameraSource!.textureId.toString(),
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
                      .surfaceContainerHighest
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
                          visible: !_hasFirstFrameRendered || !_isAudioEnabled,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6.sp),
                            child: !_isAudioEnabled || _isScreenSharing
                                ? Icon(
                                    _isScreenSharing
                                        ? PhosphorIcons.screencast_bold
                                        : PhosphorIcons.microphone_slash_fill,
                                    color: _isScreenSharing
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

  MediaSource? get _mediaSource {
    if (_isScreenSharing) {
      return participantSFU.screenSource;
    }

    return participantSFU.cameraSource;
  }

  bool get _hasFirstFrameRendered {
    if (_isScreenSharing) return true;

    return _mediaSource?.hasFirstFrameRendered ?? false;
  }

  bool get _isVideoEnabled {
    if (participantSFU.isSharingScreen) return true;

    return participantSFU.isVideoEnabled;
  }

  bool get _isAudioEnabled {
    if (participantSFU.isSharingScreen) return false;

    return participantSFU.isAudioEnabled;
  }

  bool get _isScreenSharing {
    return participantSFU.isSharingScreen;
  }

  CameraType get _cameraType {
    return participantSFU.cameraType;
  }

  AudioLevel get _audioLevel {
    if (!_isAudioEnabled) return AudioLevel.kSilence;

    return participantSFU.audioLevel;
  }

  bool get _shoundDisplayVideoRenderer {
    return _mediaSource?.stream != null && _isVideoEnabled;
  }
}
