// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
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
        final CallSetting setting = state.callSetting ?? CallSetting();

        if (WebRTC.platformIsAndroid) {
          return PipWidget(
            pipBuilder: (context) {
              return _buildPipView(context, meeting, callState);
            },
            child: MeetingBody(
              meeting: meeting,
              callState: callState,
              callSetting: setting,
            ),
          );
        }

        return MeetingBody(
          meeting: meeting,
          callSetting: setting,
          callState: callState,
        );
      },
    );
  }

  Widget _buildPipView(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
  ) {
    if (meeting.participants.length < 2) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: MeetView(
            participant: meeting.participants.first,
            callState: callState,
            avatarSize: 25.sp,
            radius: BorderRadius.horizontal(
              left: Radius.circular(10.sp),
            ),
          ),
        ),
        Expanded(
          child: MeetView(
            participant: meeting.participants[1],
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
}
