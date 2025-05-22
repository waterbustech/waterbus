import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class RoomView extends StatelessWidget {
  final EdgeInsets? margin;
  final ParticipantMediaState participantSFU;
  final List<Participant> participants;
  final double avatarSize;
  final double? width;
  final BorderRadius? radius;
  final bool borderEnabled;
  const RoomView({
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
    return StreamBuilder<AudioLevel>(
      stream: participantSFU.audioLevelStream,
      initialData: AudioLevel.kSilence,
      builder: (context, snapshot) {
        final audioLevel = snapshot.data ?? AudioLevel.kSilence;

        return Material(
          clipBehavior: Clip.hardEdge,
          type: MaterialType.card,
          color: Theme.of(context).colorScheme.onInverseSurface,
          shape: SuperellipseShape(
            side: !borderEnabled ||
                    _isScreenSharing ||
                    audioLevel == AudioLevel.kSilence
                ? BorderSide.none
                : BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: audioLevel == AudioLevel.kAudioStrong ? 8.sp : 6.sp,
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
                              ? RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitContain
                              : RTCVideoViewObjectFit
                                  .RTCVideoViewObjectFitCover,
                          mirror: !_isScreenSharing &&
                              _cameraType == CameraType.front,
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
                                    .withValues(alpha: .5),
                                Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withValues(alpha: .5),
                              ],
                              stops: const [0.1, 0.9],
                            ),
                          ),
                          child: AvatarCard(
                            urlToImage: participant?.user?.avatar,
                            size: avatarSize,
                            label: participant?.user?.fullName,
                          ),
                        ),
                  if (kIsWeb)
                    Positioned(
                      right: 10.sp,
                      top: 10.sp,
                      child: GestureWrapper(
                        onTap: () {
                          if (participantSFU.cameraSource?.textureId == null) {
                            return;
                          }

                          WaterbusSdk.instance.setPiPEnabled(
                            textureId: participantSFU.cameraSource!.textureId
                                .toString(),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .2),
                            shape: BoxShape.circle,
                          ),
                          height: 28.sp,
                          width: 28.sp,
                          alignment: Alignment.center,
                          child: Icon(
                            PhosphorIcons.cornersOut(),
                            size: 15.sp,
                          ),
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
                          .withValues(alpha: .6),
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
                              participant?.user?.fullName ?? "",
                              style: TextStyle(
                                color: participant?.isMe ?? false
                                    ? Colors.yellow
                                    : Colors.white,
                                fontSize: avatarSize / 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Visibility(
                              visible:
                                  !_hasFirstFrameRendered || !_isAudioEnabled,
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.sp),
                                child: !_isAudioEnabled || _isScreenSharing
                                    ? Icon(
                                        _isScreenSharing
                                            ? PhosphorIcons.screencast(
                                                PhosphorIconsStyle.bold,
                                              )
                                            : PhosphorIcons.microphoneSlash(
                                                PhosphorIconsStyle.fill,
                                              ),
                                        color: _isScreenSharing
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.redAccent,
                                        size: avatarSize / 5.25,
                                      )
                                    : CupertinoActivityIndicator(
                                        radius: 6.5,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                              ),
                            ),
                            // const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.sp,
                    bottom: 10.sp,
                    child: Visibility(
                      visible: _isRaisingHand,
                      child: Icon(
                        PhosphorIcons.hand(PhosphorIconsStyle.fill),
                        size: 20.sp,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Participant? get participant {
    if (participantSFU.ownerId == kIsMine) {
      return participants.firstWhereOrNull((participant) => participant.isMe);
    }

    return participants.firstWhereOrNull(
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

  bool get _isRaisingHand {
    if (participantSFU.isSharingScreen) return false;

    return participantSFU.isHandRaising;
  }

  bool get _isScreenSharing {
    return participantSFU.isSharingScreen;
  }

  CameraType get _cameraType {
    return participantSFU.cameraType;
  }

  bool get _shoundDisplayVideoRenderer {
    return _mediaSource?.stream != null && _isVideoEnabled;
  }
}
