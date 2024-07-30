import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meeting_layout.dart';
import 'package:waterbus/features/meeting/presentation/widgets/side_bar.dart';

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
  bool _isExtensionOpened = false;
  late Meeting meeting = widget.state.meeting!;
  late CallSetting callSetting = widget.state.callSetting ?? CallSetting();
  late CallState? callState = widget.state.callState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: meeting.title,
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
                    ? PhosphorIcons.speaker_high
                    : PhosphorIcons.speaker_low,
                size: 18.5.sp,
              ),
            ),
          ),
          Visibility(
            visible: SizerUtil.isDesktop,
            child: Row(
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () async {},
                  icon: Icon(
                    PhosphorIcons.users,
                    size: 20.sp,
                  ),
                ),
                Text(
                  meeting.participants.length.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
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
                if (!kIsWeb && Helper.platformIsDarwin && SizerUtil.isDesktop)
                  CallActionButton(
                    icon: PhosphorIcons.sparkle,
                    iconColor: Theme.of(context).colorScheme.primary,
                    onTap: () {
                      setState(() {
                        _isFilterSettingsOpened = !_isFilterSettingsOpened;
                      });
                    },
                  ),
                if (SizerUtil.isDesktop)
                  CallActionButton(
                    icon: Icons.subtitles_outlined,
                    backgroundColor: widget.state.isSubtitleEnabled
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    onTap: () {
                      AppBloc.meetingBloc.add(const ToggleSubtitleEvent());
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
                    AppBloc.meetingBloc.add(const LeaveMeetingEvent());
                  },
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
                    flex: _isFilterSettingsOpened || !SizerUtil.isDesktop
                        ? 0
                        : _isExtensionOpened
                            ? 7
                            : 1,
                    child: _isFilterSettingsOpened || !SizerUtil.isDesktop
                        ? const SizedBox()
                        : SideBar(
                            isExpand: _isExtensionOpened,
                            onExpandChanged: (isExpand) {
                              if (_isExtensionOpened == isExpand) return;

                              setState(() {
                                _isExtensionOpened = isExpand;
                              });
                            },
                          ),
                  ),
                  Flexible(
                    flex: _isFilterSettingsOpened
                        ? 6
                        : _isExtensionOpened
                            ? 3
                            : 20,
                    child: AnimatedContainer(
                      duration: 300.milliseconds,
                      width: _isFilterSettingsOpened
                          ? 60.w
                          : _isExtensionOpened
                              ? 30.w
                              : SizerUtil.isDesktop
                                  ? 95.w
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
                          : MeetingLayout(
                              meeting: meeting,
                              callState: callState,
                              callSetting: callSetting,
                            ),
                    ),
                  ),
                  Flexible(
                    flex: _isFilterSettingsOpened ? 4 : 0,
                    child: AnimatedContainer(
                      duration: 300.milliseconds,
                      curve: Curves.fastLinearToSlowEaseIn,
                      width: _isFilterSettingsOpened ? 40.w : 0,
                      child: _isFilterSettingsOpened
                          ? const BeautyFilterWidget()
                          : const SizedBox(),
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
