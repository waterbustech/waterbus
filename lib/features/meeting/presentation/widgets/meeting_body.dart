import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/helpers/clipboard_utils.dart';
import 'package:waterbus/core/helpers/date_time_helper.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/stack_avatar.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/chat_in_meeting.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meeting_layout.dart';
import 'package:waterbus/features/meeting/presentation/widgets/whiteboard_widget.dart';
import 'package:waterbus/gen/assets.gen.dart';

class MeetingBody extends StatefulWidget {
  final MeetingState state;
  const MeetingBody({
    super.key,
    required this.state,
  });

  @override
  State<StatefulWidget> createState() => _MeetingBodyState();
}

class _MeetingBodyState extends State<MeetingBody> {
  bool _isFilterSettingsOpened = false;
  bool _isChatOpened = false;
  bool _isWhiteBoardOpened = false;
  late Meeting meeting = widget.state.meeting!;
  late CallSetting callSetting = widget.state.callSetting ?? CallSetting();
  late CallState? callState = widget.state.callState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        toolbarHeight: SizerUtil.isDesktop ? 60.sp : null,
        titleWidget: Padding(
          padding: EdgeInsets.only(right: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meeting.title,
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
        leading: Center(child: Assets.images.imgAppLogo3d.image(height: 40.sp)),
        leadingWidth: 60.sp,
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
                  images: meeting.participants
                      .map((participant) => participant.user?.avatar)
                      .toList(),
                  size: 26.sp,
                  maxImages: 4,
                ),
                GestureWrapper(
                  onTap: () {
                    ClipboardUtils.copy(
                      meeting.code.toString().roomCodeFormatted,
                    );
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
                          ' | ${meeting.code.toString().roomCodeFormatted}',
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
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
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
                widget.state.isRecording
                    ? Material(
                        clipBehavior: Clip.hardEdge,
                        color: Colors.red,
                        shape: SuperellipseShape(
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: SizedBox(
                          height: 40.sp,
                          width: 80.sp,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                PhosphorIcons.record(PhosphorIconsStyle.fill),
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.sp),
                              Text(
                                "REC",
                                style: TextStyle(
                                  color: mCL,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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

                          AppBloc.meetingBloc.add(ToggleAudioEvent());
                        },
                      ),
                      CallActionButton(
                        icon: callState?.mParticipant == null ||
                                callState!.mParticipant!.isVideoEnabled
                            ? PhosphorIcons.camera()
                            : PhosphorIcons.cameraSlash(),
                        onTap: () {
                          if (callState?.mParticipant == null) return;

                          AppBloc.meetingBloc.add(ToggleVideoEvent());
                        },
                      ),
                      CallActionButton(
                        icon: PhosphorIcons.monitorArrowUp(),
                        onTap: () {
                          if (callState?.mParticipant == null) return;

                          if (callState!.mParticipant!.isSharingScreen) {
                            AppBloc.meetingBloc.add(StopSharingScreenEvent());
                          } else {
                            AppBloc.meetingBloc.add(StartSharingScreenEvent());
                          }
                        },
                      ),
                      CallActionButton(
                        icon: PhosphorIcons.hand(),
                        onTap: () {},
                      ),
                      CallActionButton(
                        icon: PhosphorIcons.paintBrush(),
                        onTap: () {
                          setState(() {
                            _isWhiteBoardOpened = !_isWhiteBoardOpened;
                          });
                        },
                      ),
                      CallActionButton(
                        icon: PhosphorIcons.chatTeardropText(),
                        onTap: () {
                          setState(() {
                            _isChatOpened = !_isChatOpened;
                          });
                        },
                      ),
                      CallActionButton(
                        icon: PhosphorIcons.gearSix(),
                        onTap: () {
                          showDialogWaterbus(
                            onlyShowAsDialog: true,
                            maxWidth: SizerUtil.isDesktop ? 350.sp : 290.sp,
                            paddingBottom: SizerUtil.isDesktop ? 80.sp : 20.sp,
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
                    ],
                  ),
                ),
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
                          AppBloc.meetingBloc.add(const LeaveMeetingEvent());
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
                                margin: EdgeInsets.symmetric(horizontal: 12.sp),
                                child: MeetView(
                                  participants: meeting.participants,
                                  participantSFU: callState!.mParticipant!
                                      .copyWith(isSharingScreen: false),
                                  radius: BorderRadius.zero,
                                  borderEnabled: false,
                                ),
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: MeetingLayout(
                                      meeting: meeting,
                                      callState: callState,
                                      callSetting: callSetting,
                                    ),
                                  ),
                                  Expanded(
                                    flex: _isWhiteBoardOpened ? 4 : 0,
                                    child: AnimatedSize(
                                      duration: 300.milliseconds,
                                      curve: Curves.easeInOutExpo,
                                      child: _isWhiteBoardOpened
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                top: 20.sp,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.sp,
                                              ),
                                              child: Material(
                                                clipBehavior: Clip.hardEdge,
                                                shape: SuperellipseShape(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20.sp,
                                                  ),
                                                ),
                                                child: const WhiteBoardWidget(),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
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
                                  ? ChatInMeeting(
                                      meeting: meeting,
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
                                  horizontal: SizerUtil.isDesktop ? 5.w : 16.sp,
                                ),
                                width: 100.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Material(
                                        color: Colors.black.withOpacity(.35),
                                        shape: SuperellipseShape(
                                          borderRadius: BorderRadius.circular(
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
    );
  }
}
