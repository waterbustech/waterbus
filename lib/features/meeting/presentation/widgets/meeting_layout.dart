// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/common/widgets/gridview/custom_delegate.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';

class MeetingLayout extends StatelessWidget {
  final Meeting meeting;
  final CallSetting callSetting;
  final CallState? callState;
  const MeetingLayout({
    super.key,
    required this.meeting,
    required this.callState,
    required this.callSetting,
  });

  List<ParticipantSFU> get _participants {
    final List<ParticipantSFU> participants = [];
    if (callState?.mParticipant != null) {
      final ParticipantSFU participant = callState!.mParticipant!;

      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    for (final ParticipantSFU participant
        in callState?.participants.values.toList() ?? []) {
      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    return participants;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizerUtil.isDesktop ? 16.sp : 10.sp,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isCollapsed =
              constraints.maxWidth < 30.w && SizerUtil.isDesktop;

          return _participants.length > 2 || isCollapsed
              ? _buildLayoutMultipleUsers(
                  context,
                  meeting,
                  callState,
                  callSetting,
                  constraints,
                )
              : _buildLayoutLess2Users(
                  context,
                  meeting,
                  callState,
                  constraints,
                );
        },
      ),
    );
  }

  Widget _buildLayoutLess2Users(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
    BoxConstraints constraints,
  ) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;

    final List<Widget> childrens = [
      Expanded(
        flex: _participants.length > 1 ? 1 : 2,
        child: AnimatedContainer(
          duration: 300.milliseconds,
          width: SizerUtil.isDesktop
              ? (_participants.length > 1 ? width / 2 : width)
              : double.infinity,
          height: SizerUtil.isDesktop
              ? double.infinity
              : (_participants.length > 1 ? height / 2 : height),
          curve: Curves.easeInOut,
          child: MeetView(
            participants: meeting.participants,
            participantSFU: _participants.first,
            borderEnabled: _participants.length > 1 || !SizerUtil.isDesktop,
            radius: _participants.length == 1 || SizerUtil.isDesktop
                ? BorderRadius.circular(20.sp)
                : BorderRadius.vertical(top: Radius.circular(30.sp)),
          ),
        ),
      ),
      if (SizerUtil.isDesktop) SizedBox(width: 12.sp),
      _participants.length == 1
          ? const SizedBox()
          : Expanded(
              child: AnimatedContainer(
                duration: 300.milliseconds,
                width: SizerUtil.isDesktop
                    ? (_participants.length > 1 ? width / 2 : width)
                    : double.infinity,
                height: SizerUtil.isDesktop
                    ? double.infinity
                    : (_participants.length > 1 ? height / 2 : height),
                curve: Curves.easeInOut,
                child: MeetView(
                  participants: meeting.participants,
                  participantSFU: _participants.last,
                  radius: SizerUtil.isDesktop
                      ? BorderRadius.circular(20.sp)
                      : BorderRadius.vertical(bottom: Radius.circular(30.sp)),
                ),
              ),
            ),
    ];

    return SizerUtil.isDesktop
        ? Center(
            child: SizedBox(
              height: _participants.length == 1
                  ? constraints.maxHeight
                  : constraints.maxHeight * 0.5,
              child: Row(children: childrens),
            ),
          )
        : Column(children: childrens);
  }

  Widget _buildLayoutMultipleUsers(
    BuildContext context,
    Meeting meeting,
    CallState? callState,
    CallSetting setting,
    BoxConstraints constraints,
  ) {
    final crossAxisCount =
        _gridCount(_participants.length, constraints.maxWidth);

    return GridView.builder(
      itemCount: _participants.length,
      itemBuilder: (_, index) => _buildVideoView(
        context,
        participant: _participants[index],
        callState: callState,
        avatarSize: SizerUtil.isDesktop ? 50.sp : 35.sp,
      ),
      padding: EdgeInsets.only(right: SizerUtil.isDesktop ? 20.sp : 0),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
        itemCount: crossAxisCount < 2 && SizerUtil.isDesktop
            ? 2
            : _participants.length,
        crossAxisCount: SizerUtil.isDesktop ? crossAxisCount : 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: SizerUtil.isDesktop
            ? (_participants.length <= 6 && crossAxisCount == 3 ? k43 : k169)
            : (_participants.length < 6 ? k35 : k11),
      ),
    );
  }

  Widget _buildVideoView(
    BuildContext context, {
    required ParticipantSFU participant,
    required CallState? callState,
    double? width,
    double avatarSize = 35,
    BorderRadius? radius,
  }) {
    return MeetView(
      participants: meeting.participants,
      participantSFU: participant,
      avatarSize: avatarSize,
      width: width,
      radius: radius,
    );
  }

  int _gridCount(int number, double width) {
    if (width / 300.sp < 2) return 1;

    if (number <= 4) return 2;

    return 3;
  }
}
