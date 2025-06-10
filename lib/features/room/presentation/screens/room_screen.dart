import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/room_body.dart';
import 'package:waterbus/features/room/presentation/widgets/room_view.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state is! RoomJoined || state.room == null) {
          return const SizedBox();
        }

        final Room room = state.room!;
        final CallState? callState = state.callState;

        if (WebRTC.platformIsAndroid) {
          return PipWidget(
            pipBuilder: callState == null
                ? null
                : (context) {
                    return _buildPipView(context, room, callState);
                  },
            child: RoomBody(state: state),
          );
        }

        return RoomBody(state: state);
      },
    );
  }

  Widget _buildPipView(
    BuildContext context,
    Room room,
    CallState callState,
  ) {
    return Row(
      children: [
        Expanded(
          child: RoomView(
            participantSFU: callState.mParticipant!,
            participants: room.participants,
            avatarSize: 25.sp,
          ),
        ),
        if (callState.participants.values.isNotEmpty)
          Expanded(
            child: RoomView(
              participantSFU: callState.participants.values.first,
              participants: room.participants,
              avatarSize: 25.sp,
            ),
          ),
      ],
    );
  }
}
