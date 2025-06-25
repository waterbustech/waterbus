import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class RoomView extends StatefulWidget {
  final EdgeInsets? margin;
  final ParticipantMediaState participantSFU;
  final List<Participant> participants;
  final double avatarSize;
  final double? width;
  final bool borderEnabled;

  const RoomView({
    super.key,
    required this.participantSFU,
    required this.participants,
    this.avatarSize = 80.0,
    this.borderEnabled = true,
    this.margin,
    this.width,
  });

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView>
    with AutomaticKeepAliveClientMixin {
  // Cache computed values to avoid repeated calculations
  Participant? _cachedParticipant;
  String? _cachedParticipantId;

  // Memoized getters with caching
  late final ValueNotifier<SuperellipseShape> _shapeNotifier;
  late final ValueNotifier<bool> _shouldDisplayVideoNotifier;

  @override
  bool get wantKeepAlive => true; // Keep widget alive to prevent rebuilds

  @override
  void initState() {
    super.initState();
    _shapeNotifier = ValueNotifier(_computeShape(AudioLevel.kSilence));
    _shouldDisplayVideoNotifier = ValueNotifier(_computeShouldDisplayVideo());
  }

  @override
  void dispose() {
    _shapeNotifier.dispose();
    _shouldDisplayVideoNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return RepaintBoundary(
      // Isolate repaints to this widget only
      child: StreamBuilder<AudioLevel>(
        stream: widget.participantSFU.audioLevelStream,
        initialData: AudioLevel.kSilence,
        builder: (context, snapshot) {
          final AudioLevel audioLevel = !_isAudioEnabled
              ? AudioLevel.kSilence
              : snapshot.data ?? AudioLevel.kSilence;

          // Update shape only when audio level changes
          final newShape = _computeShape(audioLevel);
          if (_shapeNotifier.value != newShape) {
            _shapeNotifier.value = newShape;
          }

          // Update video display state
          final shouldDisplay = _computeShouldDisplayVideo();
          if (_shouldDisplayVideoNotifier.value != shouldDisplay) {
            _shouldDisplayVideoNotifier.value = shouldDisplay;
          }

          return ValueListenableBuilder<SuperellipseShape>(
            valueListenable: _shapeNotifier,
            builder: (context, shape, _) {
              return Material(
                clipBehavior: Clip.hardEdge,
                type: MaterialType.card,
                color: Theme.of(context).colorScheme.onInverseSurface,
                shape: shape,
                child: SizedBox(
                  width: widget.width,
                  child: Container(
                    margin: widget.margin,
                    child: Stack(
                      children: [
                        _buildMainContent(),
                        if (kIsWeb) _buildPiPButton(),
                        _buildNameLabel(),
                        _buildHandRaiseIndicator(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return ValueListenableBuilder<bool>(
      valueListenable: _shouldDisplayVideoNotifier,
      builder: (context, shouldDisplay, _) {
        if (shouldDisplay) {
          return WaterbusMediaView(
            key: ValueKey(
              '${widget.participantSFU.ownerId}_video',
            ), // Stable key
            objectFit: _isScreenSharing || !widget.borderEnabled
                ? RTCVideoViewObjectFit.RTCVideoViewObjectFitContain
                : RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: !_isScreenSharing && _cameraType == CameraType.front,
            mediaSource: _mediaSource!,
          );
        }

        return _buildAvatarContainer();
      },
    );
  }

  Widget _buildAvatarContainer() {
    return Container(
      key: ValueKey('${widget.participantSFU.ownerId}_avatar'), // Stable key
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: .5),
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
        size: widget.avatarSize,
        label: participant?.user?.fullName,
      ),
    );
  }

  Widget _buildPiPButton() {
    return Positioned(
      right: 10.sp,
      top: 10.sp,
      child: GestureWrapper(
        onTap: () {
          final textureId = widget.participantSFU.cameraSource?.textureId;
          if (textureId != null) {
            WaterbusSdk.instance.setPictureInPictureEnabled(
              textureId: textureId.toString(),
            );
          }
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
    );
  }

  Widget _buildNameLabel() {
    return Positioned(
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
                  color:
                      participant?.isMe ?? false ? Colors.yellow : Colors.white,
                  fontSize: widget.avatarSize / 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final bool showIndicator = !_hasFirstFrameRendered || !_isAudioEnabled;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: showIndicator
          ? Padding(
              padding: EdgeInsets.only(left: 6.sp),
              child: !_isAudioEnabled || _isScreenSharing
                  ? Icon(
                      _isScreenSharing
                          ? PhosphorIcons.screencast(PhosphorIconsStyle.bold)
                          : PhosphorIcons.microphoneSlash(
                              PhosphorIconsStyle.fill,
                            ),
                      color: _isScreenSharing
                          ? Theme.of(context).colorScheme.primary
                          : Colors.redAccent,
                      size: widget.avatarSize / 5.25,
                    )
                  : CupertinoActivityIndicator(
                      radius: 6.5,
                      color: Theme.of(context).colorScheme.primary,
                    ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildHandRaiseIndicator() {
    return Positioned(
      right: 10.sp,
      bottom: 10.sp,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isRaisingHand
            ? Icon(
                PhosphorIcons.hand(PhosphorIconsStyle.fill),
                size: 20.sp,
                color: Colors.yellow,
                key: const ValueKey('hand_raised'),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // Memoized shape computation
  SuperellipseShape _computeShape(AudioLevel audioLevel) {
    return SuperellipseShape(
      side: !widget.borderEnabled ||
              _isScreenSharing ||
              audioLevel == AudioLevel.kSilence
          ? BorderSide.none
          : BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: audioLevel == AudioLevel.kAudioStrong ? 8.sp : 6.sp,
            ),
      borderRadius: BorderRadius.circular(12.sp),
    );
  }

  bool _computeShouldDisplayVideo() {
    return _mediaSource?.stream != null && _isVideoEnabled;
  }

  // Cached participant getter with memoization
  Participant? get participant {
    final currentId = widget.participantSFU.ownerId;

    // Return cached result if participant ID hasn't changed
    if (_cachedParticipantId == currentId && _cachedParticipant != null) {
      return _cachedParticipant;
    }

    _cachedParticipantId = currentId;

    if (currentId == kIsMine) {
      _cachedParticipant = widget.participants.firstWhereOrNull(
        (participant) => participant.isMe,
      );
    } else {
      _cachedParticipant = widget.participants.firstWhereOrNull(
        (participant) => participant.id.toString() == currentId,
      );
    }

    return _cachedParticipant;
  }

  // Cached getters to avoid repeated computations
  MediaSource? get _mediaSource {
    return _isScreenSharing
        ? widget.participantSFU.screenSource
        : widget.participantSFU.cameraSource;
  }

  bool get _hasFirstFrameRendered {
    if (_isScreenSharing) return true;
    return _mediaSource?.hasFirstFrameRendered ?? false;
  }

  bool get _isVideoEnabled {
    return widget.participantSFU.isSharingScreen ||
        widget.participantSFU.isVideoEnabled;
  }

  bool get _isAudioEnabled {
    return !widget.participantSFU.isSharingScreen &&
        widget.participantSFU.isAudioEnabled;
  }

  bool get _isRaisingHand {
    return !widget.participantSFU.isSharingScreen &&
        widget.participantSFU.isHandRaising;
  }

  bool get _isScreenSharing {
    return widget.participantSFU.isSharingScreen;
  }

  CameraType get _cameraType {
    return widget.participantSFU.cameraType;
  }
}
