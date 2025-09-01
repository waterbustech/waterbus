import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_pip_mode/pip_widget.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart' as sdk;

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

        final sdk.Room room = state.room!;
        final sdk.RoomState? roomState = state.roomState;

        if (sdk.WebRTC.platformIsAndroid) {
          return PipWidget(
            pipBuilder: roomState == null
                ? null
                : (context) {
                    return _buildPipView(context, room, roomState);
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
    sdk.Room room,
    sdk.RoomState roomState,
  ) {
    return Row(
      children: [
        if (roomState.localParticipant != null)
          Expanded(
            child: RoomView(
              participant: roomState.localParticipant!,
              avatarSize: 25.sp,
            ),
          ),
        if (roomState.participants.isNotEmpty)
          Expanded(
            child: RoomView(
              participant: roomState.participants.first,
              avatarSize: 25.sp,
            ),
          ),
      ],
    );
  }
}
