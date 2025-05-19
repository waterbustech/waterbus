import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/helpers/clipboard_utils.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/room/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/room/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/room/presentation/widgets/chat_in_meeting.dart';
import 'package:waterbus/features/room/presentation/widgets/room_layout.dart';
import 'package:waterbus/features/room/presentation/widgets/room_view.dart';
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
  bool _isFilterSettingsOpened = false;
  bool _isChatOpened = false;

  late Room room = widget.state.room!;
  late MediaConfig mediaConfig = widget.state.mediaConfig ?? MediaConfig();
  late CallState? callState = widget.state.callState;

  bool get _isRecordingOnPhone =>
      SizerUtil.isMobile && widget.state.isRecording;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyD, control: true): () {
          if (callState?.mParticipant == null) return;

          AppBloc.roomBloc.add(RoomAudioToggled());
        },
        const SingleActivator(LogicalKeyboardKey.keyE, control: true): () {
          if (callState?.mParticipant == null) return;

          AppBloc.roomBloc.add(RoomVideoToggled());
        },
        const SingleActivator(LogicalKeyboardKey.keyH, control: true): () {
          if (callState?.mParticipant == null) return;

          AppBloc.roomBloc.add(RoomHandRasingToggled());
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: appBarTitleBack(
            context,
            toolbarHeight: SizerUtil.isDesktop ? 60.sp : null,
            titleWidget: Padding(
              padding: EdgeInsets.only(right: SizerUtil.isDesktop ? 16.sp : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    DateTimeHelper().formatDateTime(DateTime.now()),
                    style: TextStyle(
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
            leading: Align(
              alignment: Alignment.centerRight,
              child: _isRecordingOnPhone
                  ? _buildRecWidget()
                  : Assets.icons.launcherIcon.image(height: 30.sp),
            ),
            leadingWidth: SizerUtil.isDesktop
                ? 50.sp
                : _isRecordingOnPhone
                    ? 65.sp
                    : 40.sp,
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
                    callState?.mParticipant == null ||
                            callState!.mParticipant!.isSpeakerPhoneEnabled
                        ? PhosphorIcons.speakerHigh()
                        : PhosphorIcons.speakerLow(),
                    size: 18.5.sp,
                  ),
                ),
              ),
              Visibility(
                visible: SizerUtil.isDesktop,
                child: Row(
                  children: [
                    StackAvatar(
                      label: room.participants
                          .map((participant) => participant.user?.fullName)
                          .toList(),
                      images: room.participants
                          .map((participant) => participant.user?.avatar)
                          .toList(),
                      size: 26.sp,
                      maxImages: 4,
                    ),
                    GestureWrapper(
                      onTap: () {
                        ClipboardUtils.copy(room.code.toString());
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
                              ' | ${room.code.toString()}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
                    if (SizerUtil.isDesktop)
                      widget.state.isRecording
                          ? _buildRecWidget()
                          : SizedBox(width: 80.sp),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CallActionButton(
                            icon: callState?.mParticipant == null ||
                                    callState!.mParticipant!.isAudioEnabled
                                ? PhosphorIcons.microphone()
                                : PhosphorIcons.microphoneSlash(),
                            onTap: () {
                              if (callState?.mParticipant == null) return;

                              AppBloc.roomBloc.add(RoomAudioToggled());
                            },
                          ),
                          CallActionButton(
                            icon: callState?.mParticipant == null ||
                                    callState!.mParticipant!.isVideoEnabled
                                ? PhosphorIcons.camera()
                                : PhosphorIcons.cameraSlash(),
                            onTap: () {
                              if (callState?.mParticipant == null) return;

                              AppBloc.roomBloc.add(RoomVideoToggled());
                            },
                          ),
                          CallActionButton(
                            icon: PhosphorIcons.monitorArrowUp(
                              callState!.mParticipant!.isSharingScreen
                                  ? PhosphorIconsStyle.fill
                                  : PhosphorIconsStyle.regular,
                            ),
                            iconColor: callState!.mParticipant!.isSharingScreen
                                ? Theme.of(context).colorScheme.primary
                                : null,
                            backgroundColor: callState!
                                    .mParticipant!.isSharingScreen
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                            onTap: () {
                              if (callState?.mParticipant == null) return;

                              if (callState!.mParticipant!.isSharingScreen) {
                                AppBloc.roomBloc.add(RoomSharingScreenStoped());
                              } else {
                                AppBloc.roomBloc
                                    .add(RoomSharingScreenStarted());
                              }
                            },
                          ),
                          if (SizerUtil.isDesktop)
                            CallActionButton(
                              icon: callState!.mParticipant!.isHandRaising
                                  ? PhosphorIcons.hand(PhosphorIconsStyle.fill)
                                  : PhosphorIcons.hand(),
                              iconColor: callState!.mParticipant!.isHandRaising
                                  ? Colors.yellow.shade100
                                  : null,
                              backgroundColor:
                                  callState!.mParticipant!.isHandRaising
                                      ? Colors.yellow.shade900
                                      : null,
                              onTap: () {
                                if (callState?.mParticipant == null) return;
                                AppBloc.roomBloc.add(RoomHandRasingToggled());
                              },
                            ),
                          if (SizerUtil.isDesktop)
                            CallActionButton(
                              icon: PhosphorIcons.chatTeardropText(
                                _isChatOpened
                                    ? PhosphorIconsStyle.fill
                                    : PhosphorIconsStyle.regular,
                              ),
                              iconColor: _isChatOpened
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                              backgroundColor: _isChatOpened
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : null,
                              onTap: () {
                                setState(() {
                                  _isChatOpened = !_isChatOpened;
                                });
                              },
                            ),
                          CallActionButton(
                            icon: PhosphorIcons.dotsThreeOutline(
                              PhosphorIconsStyle.fill,
                            ),
                            onTap: () {
                              showDialogWaterbus(
                                onlyShowAsDialog: true,
                                maxWidth: SizerUtil.isDesktop ? 350.sp : 290.sp,
                                paddingBottom:
                                    SizerUtil.isDesktop ? 80.sp : 20.sp,
                                paddingHorizontal: 10.sp,
                                alignment: Alignment.bottomCenter,
                                child: CallSettingsBottomSheet(
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
                          if (SizerUtil.isMobile)
                            CallActionButton(
                              icon: PhosphorIcons.signOut(),
                              backgroundColor: Colors.red,
                              onTap: () {
                                AppBloc.roomBloc.add(const RoomLeft());
                              },
                            ),
                        ],
                      ),
                    ),
                    if (SizerUtil.isDesktop)
                      Container(
                        width: 100.sp,
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CallActionButton(
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
                        flex: _isFilterSettingsOpened
                            ? 6
                            : _isChatOpened
                                ? 3
                                : 1,
                        child: AnimatedSize(
                          duration: 300.milliseconds,
                          curve: Curves.easeInOutExpo,
                          child: SizedBox(
                            width: _isFilterSettingsOpened
                                ? 60.w
                                : _isChatOpened
                                    ? 75.w
                                    : 100.w,
                            child: _isFilterSettingsOpened
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.sp),
                                    child: RoomView(
                                      participants: room.participants,
                                      participantSFU: callState!.mParticipant!
                                          .copyWith(isSharingScreen: false),
                                      radius: BorderRadius.zero,
                                      borderEnabled: false,
                                    ),
                                  )
                                : RoomLayout(
                                    room: room,
                                    callState: callState,
                                    mediaConfig: mediaConfig,
                                  ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: _isFilterSettingsOpened
                            ? 4
                            : _isChatOpened
                                ? 1
                                : 0,
                        child: AnimatedSize(
                          duration: 300.milliseconds,
                          curve: Curves.easeInOutExpo,
                          child: SizedBox(
                            width: _isFilterSettingsOpened
                                ? 40.w
                                : _isChatOpened
                                    ? 25.w
                                    : 0,
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
                                  : _isChatOpened
                                      ? ChatInRoom(
                                          room: room,
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
                  child: widget.state.subtitleStream == null
                      ? const SizedBox()
                      : StreamBuilder<String>(
                          stream: widget.state.subtitleStream,
                          builder: (context, snapshot) {
                            final String txt = snapshot.data ?? '';

                            return txt.isEmpty
                                ? const SizedBox()
                                : Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizerUtil.isDesktop ? 5.w : 16.sp,
                                    ),
                                    width: 100.w,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Material(
                                            color: Colors.black
                                                .withValues(alpha: .35),
                                            shape: SuperellipseShape(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20.sp,
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
        ),
      ),
    );
  }

  Widget _buildRecWidget() {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.red,
      shape: SuperellipseShape(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: SizedBox(
        height: SizerUtil.isDesktop ? 40.sp : 30.sp,
        width: SizerUtil.isDesktop ? 80.sp : 55.sp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.record(PhosphorIconsStyle.fill),
              size: SizerUtil.isDesktop ? 18.sp : 12.sp,
            ),
            SizedBox(width: SizerUtil.isDesktop ? 8.sp : 4.sp),
            Text(
              "REC",
              style: TextStyle(
                color: mCL,
                fontSize: SizerUtil.isDesktop ? 12.sp : 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
