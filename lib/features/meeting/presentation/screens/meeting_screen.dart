// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/core/constants/constants.dart';

// Project imports:
import 'package:waterbus/core/helpers/share_utils.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/screens/enter_meeting_password_screen.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_settings_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/e2ee_bottom_sheet.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';
import 'package:waterbus/services/webrtc/models/call_setting.dart';
import 'package:waterbus/services/webrtc/models/call_state.dart';
import 'package:waterbus/services/webrtc/models/video_layout.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

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

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: appBarTitleBack(
            context,
            '',
            titleWidget: Column(
              children: [
                GestureWrapper(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const E2eeBottomSheet();
                      },
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
            actions: [
              IconButton(
                onPressed: () async {
                  await ShareUtils().share(
                    link: meeting.inviteLink,
                    description: meeting.title,
                  );
                },
                icon: Icon(
                  PhosphorIcons.export,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.sp),
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
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.7),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.sp),
                  ),
                ),
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 12.sp).add(
                  EdgeInsets.only(bottom: 12.sp),
                ),
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
                      onTap: () {},
                    ),
                    CallActionButton(
                      icon: PhosphorIcons.gear_six,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const CallSettingsBottomSheet();
                          },
                        );
                      },
                    ),
                    CallActionButton(
                      icon: PhosphorIcons.x,
                      backgroundColor: Colors.red,
                      onTap: () {
                        displayLoadingLayer();
                        AppBloc.meetingBloc.add(LeaveMeetingEvent());
                      },
                    ),
                  ],
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
      },
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
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        child: meeting.users.length > 2
            ? _buildLayoutMultipleUsers(context, meeting, callState, setting)
            : Material(
                clipBehavior: Clip.hardEdge,
                shape: SuperellipseShape(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                child: _buildLayoutLess2Users(context, meeting, callState),
              ),
      ),
    );
  }

  Widget _buildLayoutLess2Users(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
  ) {
    return Column(
      children: meeting.users
          .map<Widget>(
            (participant) => Expanded(
              child: MeetView(
                participant: participant,
                callState: callState,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLayoutMultipleUsers(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
    CallSetting setting,
  ) {
    return setting.videoLayout == VideoLayout.gridView &&
            meeting.users.length >= gridViewMinUsers
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
  }) {
    return Material(
      clipBehavior: Clip.hardEdge,
      shape: SuperellipseShape(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1.sp,
        ),
        borderRadius: BorderRadius.circular(18.sp),
      ),
      child: SizedBox(
        width: width,
        child: MeetView(
          participant: participant,
          avatarSize: 35.sp,
          callState: callState,
        ),
      ),
    );
  }
}
