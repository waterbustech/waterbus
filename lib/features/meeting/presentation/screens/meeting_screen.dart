// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/helpers/extensions/duration_extensions.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/screens/enter_meeting_password_screen.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/e2ee_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state is PreJoinMeeting) {
          return EnterMeetingPasswordScreen(meeting: state.meeting!);
        }

        if (state is! JoinedMeeting || state.meeting == null) {
          return const SizedBox();
        }

        final Meeting meeting = state.meeting!;
        final CallState? callState = state.callState;
        final CallSetting setting = state.callSetting ?? CallSetting();

        if (WebRTC.platformIsAndroid) {
          return PipWidget(
            pipBuilder: (context) {
              return _buildPipView(context, meeting, callState);
            },
            child: _buildMeetingBody(
              context,
              meeting: meeting,
              callState: callState,
              setting: setting,
            ),
          );
        }

        return _buildMeetingBody(
          context,
          meeting: meeting,
          callState: callState,
          setting: setting,
        );
      },
    );
  }

  Widget _buildMeetingBody(
    context, {
    required Meeting meeting,
    required CallState? callState,
    required CallSetting setting,
  }) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      endDrawer: WebRTC.platformIsMacOS
          ? Drawer(
              width: 40.w,
              child: BeautyFilterWidget(
                participant: meeting.participants
                    .firstWhere((participant) => participant.isMe),
                callState: callState,
              ),
            )
          : null,
      appBar: appBarTitleBack(
        context,
        '',
        titleWidget: Padding(
          padding: EdgeInsets.only(left: 32.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureWrapper(
                onTap: () {
                  showDialogWaterbus(
                    alignment: Alignment.center,
                    child: const E2eeBottomSheet(),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.lock_fill,
                      color: Colors.green,
                      size: 9.sp,
                    ),
                    SizedBox(width: 4.sp),
                    Text(
                      'End-to-end encrypted',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.sp),
              Text(
                meeting.code.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Visibility(
            visible: WebRTC.platformIsMobile,
            child: IconButton(
              onPressed: () async {
                WaterbusSdk.instance.switchCamera();
                DeviceUtils().lightImpact();
              },
              icon: Icon(
                PhosphorIcons.camera_rotate,
                size: 20.sp,
              ),
            ),
          ),
          Visibility(
            visible: WebRTC.platformIsMacOS,
            child: IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {
                if (WebRTC.platformIsMacOS) {
                  _scaffoldKey.currentState?.openEndDrawer();
                }
              },
              icon: Icon(
                PhosphorIcons.magic_wand,
                size: 22.sp,
              ),
            ),
          ),
          IconButton(
            alignment: Alignment.centerRight,
            onPressed: () async {
              if (WebRTC.platformIsDesktop) {
                showDialogWaterbus(
                  alignment: Alignment.center,
                  child: const E2eeBottomSheet(),
                );
              } else {
                WaterbusSdk.instance.toggleSpeakerPhone();
                DeviceUtils().lightImpact();
              }
            },
            icon: Icon(
              WebRTC.platformIsDesktop || kIsWeb
                  ? PhosphorIcons.lock
                  : callState?.mParticipant == null ||
                          callState!.mParticipant!.isSpeakerPhoneEnabled
                      ? PhosphorIcons.speaker_high
                      : PhosphorIcons.speaker_low,
              size: SizerUtil.isDesktop ? 22.sp : 18.5.sp,
            ),
          ),
          SizedBox(width: 4.sp),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.sp),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 30,
          ),
          child: Container(
            height: 80.sp,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.sp),
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 12.sp).add(
              EdgeInsets.only(bottom: 12.sp),
            ),
            child: SizedBox(
              width: SizerUtil.isDesktop ? 350.sp : double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CallActionButton(
                    icon: callState?.mParticipant == null ||
                            callState!.mParticipant!.isAudioEnabled
                        ? PhosphorIcons.microphone
                        : PhosphorIcons.microphone_slash,
                    onTap: () {
                      if (callState?.mParticipant == null) return;

                      AppBloc.meetingBloc.add(ToggleAudioEvent());
                    },
                  ),
                  CallActionButton(
                    icon: callState?.mParticipant == null ||
                            callState!.mParticipant!.isVideoEnabled
                        ? PhosphorIcons.camera
                        : PhosphorIcons.camera_slash,
                    onTap: () {
                      if (callState?.mParticipant == null) return;

                      AppBloc.meetingBloc.add(ToggleVideoEvent());
                    },
                  ),
                  CallActionButton(
                    icon: PhosphorIcons.screencast,
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
                    icon: PhosphorIcons.gear_six,
                    onTap: () {
                      showDialogWaterbus(
                        alignment: Alignment.center,
                        child: const CallSettingsBottomSheet(),
                      );
                    },
                  ),
                  CallActionButton(
                    icon: PhosphorIcons.x,
                    backgroundColor: Colors.red,
                    onTap: () {
                      displayLoadingLayer();
                      AppBloc.meetingBloc.add(const LeaveMeetingEvent());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildMeetingView(
              context: context,
              meeting: meeting,
              callState: callState,
              setting: setting,
            ),
            SizedBox(height: 12.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingView({
    required BuildContext context,
    required Meeting meeting,
    required CallState? callState,
    required CallSetting setting,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: SizerUtil.isDesktop ? 16.sp : 10.sp,
        ),
        child: meeting.users.length > 2
            ? _buildLayoutMultipleUsers(context, meeting, callState, setting)
            : _buildLayoutLess2Users(context, meeting, callState),
      ),
    );
  }

  Widget _buildPipView(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
  ) {
    if (meeting.users.length < 2) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: MeetView(
            participant: meeting.users.first,
            callState: callState,
            avatarSize: 25.sp,
            radius: BorderRadius.horizontal(
              left: Radius.circular(10.sp),
            ),
          ),
        ),
        Expanded(
          child: MeetView(
            participant: meeting.users[1],
            callState: callState,
            avatarSize: 25.sp,
            radius: BorderRadius.horizontal(
              right: Radius.circular(10.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayoutLess2Users(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
  ) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final double notchHeight = devicePadding.top;
    final double width = 100.w - 32.sp;
    final double height = 100.h - notchHeight - kToolbarHeight - 100.sp;
    final List<Widget> childrens = [
      AnimatedContainer(
        duration: 300.milliseconds,
        width: SizerUtil.isDesktop
            ? (meeting.users.length > 1 ? width / 2 : width)
            : double.infinity,
        height: SizerUtil.isDesktop
            ? double.infinity
            : (meeting.users.length > 1 ? height / 2 : height),
        curve: Curves.easeInOut,
        child: MeetView(
          participant: meeting.users.first,
          callState: callState,
          borderEnabled: meeting.users.length > 1 || !SizerUtil.isDesktop,
          radius: meeting.users.length == 1
              ? BorderRadius.circular(20.sp)
              : SizerUtil.isDesktop
                  ? BorderRadius.only(
                      bottomRight: Radius.circular(30.sp),
                      topLeft: Radius.circular(30.sp),
                    )
                  : BorderRadius.vertical(top: Radius.circular(30.sp)),
        ),
      ),
      meeting.users.length == 1
          ? const SizedBox()
          : Expanded(
              child: MeetView(
                participant: meeting.participants.last,
                callState: callState,
                radius: SizerUtil.isDesktop
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp),
                      )
                    : BorderRadius.vertical(bottom: Radius.circular(30.sp)),
              ),
            ),
    ];

    return SizerUtil.isDesktop
        ? Row(children: childrens)
        : Column(children: childrens);
  }

  Widget _buildLayoutMultipleUsers(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
    CallSetting setting,
  ) {
    return setting.videoLayout == VideoLayout.gridView &&
            meeting.users.length >= kGridViewMinUsers
        ? GridView.custom(
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: const [
                QuiltedGridTile(3, 2),
                QuiltedGridTile(2, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              childCount: meeting.users.length,
              (context, index) => index >= meeting.users.length
                  ? const SizedBox()
                  : _buildVideoView(
                      context,
                      participant: meeting.users[index],
                      callState: callState,
                    ),
            ),
          )
        : Column(
            children: [
              Expanded(
                flex: 3,
                child: _buildVideoView(
                  context,
                  participant: meeting.users.first,
                  callState: callState,
                ),
              ),
              SizedBox(height: 6.sp),
              Expanded(
                child: setting.videoLayout == VideoLayout.gridView
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildVideoView(
                              context,
                              participant: meeting.users[1],
                              callState: callState,
                            ),
                          ),
                          SizedBox(width: 4.sp),
                          Expanded(
                            child: _buildVideoView(
                              context,
                              participant: meeting.users[2],
                              callState: callState,
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: meeting.users.length - 1,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 6.sp),
                            child: _buildVideoView(
                              context,
                              participant: meeting.users[index + 1],
                              callState: callState,
                              width: 150.sp,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
  }

  Widget _buildVideoView(
    BuildContext context, {
    required Participant participant,
    required CallState? callState,
    double? width,
    BorderRadius? radius,
  }) {
    return MeetView(
      participant: participant,
      callState: callState,
      avatarSize: 35.sp,
      width: width,
      radius: radius,
    );
  }
}
