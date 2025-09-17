import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart' hide RoomState;
import 'package:waterbus_sdk/types/index.dart' as sdk;
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/constants/color_constants.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/clipboard_utils.dart';
import 'package:waterbus/core/utils/device_utils.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/common/widgets/tooltip_message.dart';
import 'package:waterbus/features/home/presentation/widgets/stack_avatar.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/room/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/room/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/room/presentation/widgets/chat_in_room.dart';
import 'package:waterbus/features/room/presentation/widgets/media_call_action_button.dart';
import 'package:waterbus/features/room/presentation/widgets/room_layout.dart';
import 'package:waterbus/features/room/presentation/widgets/room_view.dart';
import 'package:waterbus/features/room/presentation/widgets/time_display.dart';
import 'package:waterbus/features/room/presentation/widgets/virtual_background_in_room.dart';
import 'package:waterbus/gen/assets.gen.dart';

class RoomBody extends StatefulWidget {
  final RoomState state;
  const RoomBody({
    super.key,
    required this.state,
  });

  @override
  State<StatefulWidget> createState() => _RoomBodyState();
}

class _RoomBodyState extends State<RoomBody> {
  late RoomState _state;
  late Room _room;
  late sdk.RoomState _roomState;

  final List<MediaDeviceInfo> _audioInputs = [];
  final List<MediaDeviceInfo> _audioOutputs = [];
  final List<MediaDeviceInfo> _videoInputs = [];
  final GlobalKey _audioInputButtonKey = GlobalKey();
  final GlobalKey _videoInputButtonKey = GlobalKey();

  OverlayEntry? _overlay;
  MediaDeviceInfo? _audioInputSelected;
  MediaDeviceInfo? _videoInputSelected;
  bool _isFilterSettingsOpened = false;
  bool _isChatOpened = false;
  bool _isVirtualBackground = false;

  @override
  void initState() {
    super.initState();
    _initValues();
    _audioInputs.addAll(AppBloc.roomBloc.audioInputs);
    _videoInputs.addAll(AppBloc.roomBloc.videoInputs);
    _audioOutputs.addAll(AppBloc.roomBloc.audioOutputs);

    _audioInputSelected = AppBloc.roomBloc.audioInputSelected;
    _videoInputSelected = AppBloc.roomBloc.videoInputSelected;
  }

  void _showMicrophoneMenu(
    BuildContext context, {
    required List<MediaDeviceInfo> deviceLst,
    required GlobalKey key,
    required MediaDeviceInfo? deviceInfoSelected,
    required Function(MediaDeviceInfo)? onSelectDevice,
    required Function() removeOverlay,
  }) {
    if (_overlay != null) return;

    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;

    final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

    _overlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: buttonPosition.dx,
              top: buttonPosition.dy -
                  deviceLst.length * 36.sp -
                  5.sp -
                  8.sp * 2,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(deviceLst.length, (index) {
                      return GestureWrapper(
                        isHovered: true,
                        onTap: () => onSelectDevice?.call(deviceLst[index]),
                        child: Container(
                          width: 250.sp,
                          height: 36.sp,
                          padding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 10.sp,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.sp),
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.sp,
                                child: deviceLst[index] == deviceInfoSelected
                                    ? PhosphorIcon(
                                        PhosphorIcons.check(),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 18.sp,
                                      )
                                    : SizedBox.shrink(),
                              ),
                              SizedBox(width: 10.sp),
                              Text(
                                deviceLst[index].label,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (_overlay != null) {
      Overlay.of(context).insert(_overlay!);
    }
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  @override
  void didUpdateWidget(RoomBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == oldWidget.state) return;

    _initValues();
  }

  void _initValues() {
    _state = widget.state;
    _room = _state.room!;
    _roomState = _state.roomState!;
  }

  bool get _currentUserMedia => _localParticipant == null;
  Participant? get _localParticipant => _roomState.localParticipant;
  bool get _isSpeakerPhoneEnabled =>
      _localParticipant?.isSpeakerPhoneEnabled ?? false;
  bool get _isVideoEnabled => _localParticipant?.isVideoEnabled ?? false;
  bool get _isAudioEnabled => _localParticipant?.isAudioEnabled ?? false;
  bool get _isHandRaising => _localParticipant?.isHandRaising ?? false;
  bool get _isSharingScreen => _localParticipant?.isSharingScreen ?? false;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyD, control: true): () {
          if (_currentUserMedia) return;

          AppBloc.roomBloc.add(RoomAudioToggled());
        },
        const SingleActivator(LogicalKeyboardKey.keyE, control: true): () {
          if (_currentUserMedia) return;

          AppBloc.roomBloc.add(RoomVideoToggled());
        },
        const SingleActivator(LogicalKeyboardKey.keyH, control: true): () {
          if (_currentUserMedia) return;

          AppBloc.roomBloc.add(RoomHandRasingToggled());
        },
      },
      child: Focus(
        autofocus: true,
        child: _bodyWidget(context),
      ),
    );
  }

  Scaffold _bodyWidget(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        toolbarHeight: context.isDesktop ? 60.sp : null,
        titleWidget: Padding(
          padding: EdgeInsets.only(right: context.isDesktop ? 16.sp : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _room.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TimeDisplay(),
            ],
          ),
        ),
        centerTitle: false,
        leading: Align(
          alignment: Alignment.centerRight,
          child: Assets.icons.launcherIcon.image(height: 30.sp),
        ),
        leadingWidth: context.isDesktop ? 50.sp : 40.sp,
        actions: [
          Visibility(
            visible: WebRTC.platformIsMobile,
            child: IconButton(
              onPressed: () async {
                WaterbusSdk.instance.switchCamera();
                DeviceUtils().lightImpact();
              },
              icon: Icon(
                PhosphorIcons.cameraRotate(),
                size: 20.sp,
              ),
            ),
          ),
          Visibility(
            visible: WebRTC.platformIsMobile,
            child: IconButton(
              alignment: Alignment.centerRight,
              onPressed: () async {
                await WaterbusSdk.instance.toggleSpeakerPhone();
                DeviceUtils().lightImpact();
              },
              icon: Icon(
                _currentUserMedia || _isSpeakerPhoneEnabled
                    ? PhosphorIcons.speakerHigh()
                    : PhosphorIcons.speakerLow(),
                size: 18.5.sp,
              ),
            ),
          ),
          Visibility(
            visible: context.isDesktop,
            child: Row(
              children: [
                StackAvatar(
                  label: _room.participants
                      .map((participant) => participant.user?.fullName)
                      .toList(),
                  images: _room.participants
                      .map((participant) => participant.user?.avatar)
                      .toList(),
                  size: 26.sp,
                  maxImages: 4,
                ),
                TooltipWrapper(
                  message: Strings.copy.i18n,
                  child: GestureWrapper(
                    onTap: () {
                      ClipboardUtils.copyMeetLink(_room.code.toString());
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 12.sp),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 8.sp,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.sp),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            PhosphorIcons.linkSimpleHorizontal(),
                            size: 18.sp,
                          ),
                          Text(
                            ' | ${_room.code.toString()}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.sp),
              ],
            ),
          ),
          SizedBox(width: 4.sp),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 58.sp,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .scaffoldBackgroundColor
                .withValues(alpha: 0.7),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.sp),
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.symmetric(horizontal: 12.sp).add(
            EdgeInsets.only(bottom: 12.sp),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp),
            width: double.infinity,
            child: Row(
              children: [
                if (context.isDesktop)
                  _state.isRecording
                      ? _buildRecWidget()
                      : SizedBox(width: 80.sp),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaCallActionButton(
                        key: _audioInputButtonKey,
                        onTap: () {
                          if (_currentUserMedia) {
                            return;
                          }

                          AppBloc.roomBloc.add(RoomAudioToggled());
                        },
                        icon: _currentUserMedia || _isAudioEnabled
                            ? PhosphorIcons.microphone(
                                PhosphorIconsStyle.fill,
                              )
                            : PhosphorIcons.microphoneSlash(
                                PhosphorIconsStyle.fill,
                              ),
                        title: 'Microphone',
                        onSelectMediaDevice: () {
                          _handleSelectAudioOutput(context);
                        },
                        settingTooltipMessage: Strings.audioSettings.i18n,
                        tooltipMessage:
                            "${_isVideoEnabled ? Strings.micOff.i18n : Strings.micOn.i18n} (ctrl + d)",
                      ),
                      MediaCallActionButton(
                        key: _videoInputButtonKey,
                        onTap: () {
                          if (_currentUserMedia) return;

                          AppBloc.roomBloc.add(RoomVideoToggled());
                        },
                        icon: _currentUserMedia || _isVideoEnabled
                            ? PhosphorIcons.videoCamera(
                                PhosphorIconsStyle.fill,
                              )
                            : PhosphorIcons.videoCameraSlash(
                                PhosphorIconsStyle.fill,
                              ),
                        title: Strings.camera.i18n,
                        onSelectMediaDevice: () {
                          _handleSelectVideoOutput(context);
                        },
                        settingTooltipMessage: Strings.videoSettings.i18n,
                        tooltipMessage:
                            "${_isVideoEnabled ? Strings.cameraOff.i18n : Strings.cameraOn.i18n} (ctrl + e)",
                      ),
                      CallActionButton(
                        tooltipMessage: Strings.shareScreen.i18n,
                        icon: PhosphorIcons.monitorArrowUp(
                          _isSharingScreen
                              ? PhosphorIconsStyle.fill
                              : PhosphorIconsStyle.regular,
                        ),
                        iconColor: _isSharingScreen
                            ? Theme.of(context).colorScheme.primary
                            : null,
                        backgroundColor: _isSharingScreen
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        onTap: () {
                          if (_currentUserMedia) return;

                          if (_isSharingScreen) {
                            AppBloc.roomBloc.add(RoomSharingScreenStoped());
                          } else {
                            AppBloc.roomBloc.add(RoomSharingScreenStarted());
                          }
                        },
                      ),
                      if (context.isDesktop)
                        CallActionButton(
                          tooltipMessage:
                              "${Strings.raiseHand.i18n} (ctrl + h)",
                          icon: _isHandRaising
                              ? PhosphorIcons.hand(PhosphorIconsStyle.fill)
                              : PhosphorIcons.hand(),
                          iconColor:
                              _isHandRaising ? Colors.yellow.shade100 : null,
                          backgroundColor:
                              _isHandRaising ? Colors.yellow.shade900 : null,
                          onTap: () {
                            if (_currentUserMedia) return;

                            AppBloc.roomBloc.add(RoomHandRasingToggled());
                          },
                        ),
                      if (context.isDesktop)
                        CallActionButton(
                          tooltipMessage: Strings.chatWithEveryone.i18n,
                          icon: PhosphorIcons.chatTeardropText(
                            _isChatOpened
                                ? PhosphorIconsStyle.fill
                                : PhosphorIconsStyle.regular,
                          ),
                          iconColor: _isChatOpened
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          backgroundColor: _isChatOpened
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          onTap: () {
                            setState(() {
                              if (_isVirtualBackground) {
                                _isVirtualBackground = false;
                              }

                              _isChatOpened = !_isChatOpened;
                            });
                          },
                        ),
                      CallActionButton(
                        tooltipMessage: Strings.moreOptions.i18n,
                        icon: PhosphorIcons.dotsThreeOutline(
                          PhosphorIconsStyle.fill,
                        ),
                        onTap: () {
                          showDialogWaterbus(
                            onlyShowAsDialog: true,
                            maxWidth: context.isDesktop ? 350.sp : 290.sp,
                            paddingBottom: context.isDesktop ? 80.sp : 20.sp,
                            paddingHorizontal: 10.sp,
                            alignment: Alignment.bottomCenter,
                            child: CallSettingsBottomSheet(
                              onVirtualBackground: () {
                                setState(() {
                                  if (_isChatOpened) {
                                    _isChatOpened = false;
                                  }

                                  _isVirtualBackground = !_isVirtualBackground;
                                });
                              },
                              onBeautyFiltersTapped: () {
                                setState(() {
                                  _isFilterSettingsOpened =
                                      !_isFilterSettingsOpened;
                                });
                              },
                            ),
                          );
                        },
                      ),
                      if (context.isMobile)
                        CallActionButton(
                          tooltipMessage: Strings.leaveCall.i18n,
                          icon: PhosphorIcons.signOut(),
                          backgroundColor: Colors.red,
                          onTap: () {
                            AppBloc.roomBloc.add(const RoomLeft());
                          },
                        ),
                    ],
                  ),
                ),
                if (context.isDesktop)
                  Container(
                    width: 100.sp,
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CallActionButton(
                          tooltipMessage: Strings.leaveCall.i18n,
                          icon: PhosphorIcons.signOut(),
                          backgroundColor: Colors.red,
                          onTap: () {
                            AppBloc.roomBloc.add(const RoomLeft());
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.sp),
              child: Row(
                children: [
                  Flexible(
                    flex: 100 - _getRightPanelWidth,
                    child: AnimatedSize(
                      duration: 300.milliseconds,
                      curve: Curves.easeInOutExpo,
                      child: SizedBox(
                        width: (100 - _getRightPanelWidth).w,
                        child: _isFilterSettingsOpened && _currentUserMedia
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.sp),
                                child: RoomView(
                                  participant: _roomState.localParticipant!
                                      .copyWith(isSharingScreen: false),
                                  borderEnabled: false,
                                ),
                              )
                            : RoomLayout(
                                room: _room,
                                roomState: _roomState,
                              ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: _getRightPanelWidth,
                    child: AnimatedSize(
                      duration: 300.milliseconds,
                      curve: Curves.easeInOutExpo,
                      child: SizedBox(
                        width: _getRightPanelWidth.w,
                        child: AnimatedSwitcher(
                          duration: 300.milliseconds,
                          child: _isFilterSettingsOpened
                              ? BeautyFilterWidget(
                                  handleClosed: () {
                                    setState(() {
                                      _isFilterSettingsOpened = false;
                                    });
                                  },
                                )
                              : _isVirtualBackground
                                  ? VirtualBackgroundInRoom(
                                      onClosePressed: () {
                                        setState(() {
                                          _isVirtualBackground = false;
                                        });
                                      },
                                    )
                                  : _isChatOpened
                                      ? ChatInRoom(
                                          room: _room,
                                          onClosePressed: () {
                                            setState(() {
                                              _isChatOpened = false;
                                            });
                                          },
                                        )
                                      : const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Build subtitle
            Positioned(
              bottom: 20.sp,
              child: _state.subtitleStream == null
                  ? const SizedBox()
                  : StreamBuilder<String>(
                      stream: _state.subtitleStream,
                      builder: (context, snapshot) {
                        final String txt = snapshot.data ?? '';

                        return txt.isEmpty
                            ? const SizedBox()
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.isDesktop ? 5.w : 16.sp,
                                ),
                                width: 100.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Material(
                                        color:
                                            Colors.black.withValues(alpha: .35),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.sp,
                                          ),
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.sp,
                                            vertical: 12.sp,
                                          ),
                                          child: Text(
                                            txt,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int get _getRightPanelWidth {
    return _isFilterSettingsOpened
        ? 40
        : _isChatOpened || _isVirtualBackground
            ? 25
            : 0;
  }

  void _handleSelectVideoOutput(BuildContext context) {
    if (_overlay != null) return _removeOverlay();

    _showMicrophoneMenu(
      context,
      deviceLst: _videoInputs,
      key: _videoInputButtonKey,
      onSelectDevice: (option) {
        setState(() {
          _removeOverlay();
          _videoInputSelected = option;
        });

        if (_videoInputSelected == null) return;

        AppBloc.roomBloc.add(
          RoomVideoDeviceToggled(
            mediaDeviceInfo: _videoInputSelected!,
          ),
        );
      },
      removeOverlay: _removeOverlay,
      deviceInfoSelected: _videoInputSelected,
    );
  }

  void _handleSelectAudioOutput(BuildContext context) {
    if (_overlay != null) return _removeOverlay();

    _showMicrophoneMenu(
      context,
      deviceLst: _audioInputs,
      key: _audioInputButtonKey,
      deviceInfoSelected: _audioInputSelected,
      onSelectDevice: (option) {
        setState(() {
          _audioInputSelected = option;
          _removeOverlay();
        });

        if (_audioInputSelected == null) return;

        AppBloc.roomBloc.add(
          RoomAudioDeviceToggled(
            mediaDeviceInfo: _audioInputSelected!,
          ),
        );
      },
      removeOverlay: _removeOverlay,
    );
  }

  Widget _buildRecWidget() {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.sp),
      ),
      child: SizedBox(
        height: context.isDesktop ? 40.sp : 30.sp,
        width: context.isDesktop ? 80.sp : 55.sp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.record(PhosphorIconsStyle.fill),
              size: context.isDesktop ? 18.sp : 12.sp,
            ),
            SizedBox(width: context.isDesktop ? 8.sp : 4.sp),
            Text(
              "REC",
              style: TextStyle(
                color: mCL,
                fontSize: context.isDesktop ? 12.sp : 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
