import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/screens/enter_meeting_password_screen.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meeting_body.dart';

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

        if (WebRTC.platformIsAndroid) {
          return PipWidget(
            pipBuilder: callState == null
                ? null
                : (context) {
                    return _buildPipView(context, meeting, callState);
                  },
            child: MeetingBody(
              state: state,
            ),
          );
        }

        return MeetingBody(
          state: state,
        );
      },
    );
  }

  Widget _buildPipView(
    BuildContext context,
    Meeting meeting,
    CallState callState,
  ) {
    return Row(
      children: [
        Expanded(
          child: MeetView(
            participantSFU: callState.mParticipant!,
            participants: meeting.participants,
            avatarSize: 25.sp,
            radius: BorderRadius.horizontal(
              left: Radius.circular(10.sp),
            ),
          ),
        ),
        if (callState.participants.values.isNotEmpty)
          Expanded(
            child: MeetView(
              participantSFU: callState.participants.values.first,
              participants: meeting.participants,
              avatarSize: 25.sp,
              radius: BorderRadius.horizontal(
                right: Radius.circular(10.sp),
              ),
            ),
          ),
      ],
    );
  }
}
