import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/room/presentation/widgets/stats_view.dart';

class RoomView extends StatefulWidget {
  final EdgeInsets? margin;
  final Participant participant;
  final double avatarSize;
  final double? width;
  final bool borderEnabled;

  const RoomView({
    super.key,
    required this.participant,
    this.avatarSize = 80.0,
    this.borderEnabled = true,
    this.margin,
    this.width,
  });

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  // Memoized getters with caching
  late final ValueNotifier<Decoration> _shapeNotifier;
  late final ValueNotifier<bool> _shouldDisplayVideoNotifier;
  late Participant _participant;

  @override
  void initState() {
    super.initState();
    _participant = widget.participant;
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
    return StreamBuilder<AudioLevel>(
      stream: _participant.audioLevelStream,
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

        return ValueListenableBuilder<Decoration>(
          valueListenable: _shapeNotifier,
          builder: (context, shape, _) {
            final bool isHls = _mediaSource?.isHls ?? false;

            return Container(
              margin: widget.margin,
              decoration: shape,
              width: widget.width,
              child: Stack(
                children: [
                  _buildMainContent(),
                  if (kIsWeb && !isHls) _buildPiPButton(),
                  if (!isHls) _buildNameLabel(),
                  _buildHandRaiseIndicator(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMainContent() {
    return ValueListenableBuilder<bool>(
      valueListenable: _shouldDisplayVideoNotifier,
      builder: (context, shouldDisplay, _) {
        if (shouldDisplay) {
          return WaterbusMediaView(
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
      key: ValueKey('${_participant.ownerId}_avatar'), // Stable key
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
        urlToImage: _participant.info.user?.avatar,
        size: widget.avatarSize,
        label: _participant.info.user?.fullName,
      ),
    );
  }

  Widget _buildPiPButton() {
    return Positioned(
      right: 10.sp,
      bottom: 10.sp,
      child: GestureWrapper(
        onTap: () {
          final textureId = _participant.cameraSource?.textureId;
          if (textureId != null) {
            WaterbusSdk.instance.setPictureInPictureEnabled(
              textureId: textureId.toString(),
            );
          }
        },
        child: Icon(
          LucideIcons.pictureInPicture,
          size: 22.sp,
        ),
      ),
    );
  }

  Widget _buildNameLabel() {
    return Positioned(
      left: 10.sp,
      bottom: 10.sp,
      child: GestureWrapper(
        onTap: () {
          showDialogWaterbus(
            alignment: Alignment.center,
            duration: 200.milliseconds.inMilliseconds,
            maxHeight: context.isDesktop ? 450.sp : double.infinity,
            maxWidth: context.isDesktop ? 750.sp : null,
            child: StatsView(
              participant: _participant,
              isScreenShare: _isScreenSharing,
            ),
          );
        },
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.sp),
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
                  _participant.info.user?.fullName ?? "Waterbus",
                  style: TextStyle(
                    color: _participant is LocalParticipant
                        ? Colors.yellow
                        : Colors.white,
                    fontSize: widget.avatarSize / 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusIndicator(),
                SizedBox(width: 4.sp),
                Icon(
                  LucideIcons.chartNoAxesColumnIncreasing,
                  size: widget.avatarSize / 6,
                  color: Colors.greenAccent,
                ),
              ],
            ),
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
  Decoration _computeShape(AudioLevel audioLevel) {
    return BoxDecoration(
      border: !widget.borderEnabled ||
              _isScreenSharing ||
              audioLevel == AudioLevel.kSilence
          ? null
          : Border.all(
              color: Theme.of(AppRouter.context!).colorScheme.primary,
              width: audioLevel == AudioLevel.kAudioStrong ? 4.sp : 2.sp,
            ),
      color: Theme.of(AppRouter.context!).colorScheme.surfaceDim.withValues(
            alpha: 0.25,
          ),
      borderRadius: BorderRadius.circular(2.sp),
    );
  }

  bool _computeShouldDisplayVideo() {
    return (_mediaSource?.stream != null && _isVideoEnabled) ||
        (_mediaSource?.isHls ?? false);
  }

  // Cached getters to avoid repeated computations
  MediaSource? get _mediaSource {
    return _isScreenSharing
        ? _participant.screenSource
        : _participant.cameraSource;
  }

  bool get _hasFirstFrameRendered {
    if (_isScreenSharing) return true;
    return _mediaSource?.hasFirstFrameRendered ?? false;
  }

  bool get _isVideoEnabled {
    return _isScreenSharing || _participant.isVideoEnabled;
  }

  bool get _isAudioEnabled {
    return !_isScreenSharing && _participant.isAudioEnabled;
  }

  bool get _isRaisingHand {
    return !_isScreenSharing && _participant.isHandRaising;
  }

  bool get _isScreenSharing {
    return _participant.isSharingScreen;
  }

  CameraType get _cameraType {
    return _participant.cameraType;
  }
}
