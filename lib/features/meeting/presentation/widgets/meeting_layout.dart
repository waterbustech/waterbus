// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/models/call_setting.dart';
import 'package:waterbus_sdk/models/call_state.dart';

// Project imports:
import 'package:waterbus/core/types/extensions/duration_x.dart';
import 'package:waterbus/features/common/widgets/gridview/custom_delegate.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
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

          return meeting.participants.length > 2 || isCollapsed
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
        flex: meeting.participants.length > 1 ? 1 : 2,
        child: AnimatedContainer(
          duration: 300.milliseconds,
          width: SizerUtil.isDesktop
              ? (meeting.participants.length > 1 ? width / 2 : width)
              : double.infinity,
          height: SizerUtil.isDesktop
              ? double.infinity
              : (meeting.participants.length > 1 ? height / 2 : height),
          curve: Curves.easeInOut,
          child: MeetView(
            participant: meeting.participants.first,
            callState: callState,
            borderEnabled:
                meeting.participants.length > 1 || !SizerUtil.isDesktop,
            radius: meeting.participants.length == 1
                ? BorderRadius.circular(20.sp)
                : SizerUtil.isDesktop
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(30.sp),
                        topLeft: Radius.circular(30.sp),
                      )
                    : BorderRadius.vertical(top: Radius.circular(30.sp)),
          ),
        ),
      ),
      meeting.participants.length == 1
          ? const SizedBox()
          : Expanded(
              child: AnimatedContainer(
                duration: 300.milliseconds,
                width: SizerUtil.isDesktop
                    ? (meeting.participants.length > 1 ? width / 2 : width)
                    : double.infinity,
                height: SizerUtil.isDesktop
                    ? double.infinity
                    : (meeting.participants.length > 1 ? height / 2 : height),
                curve: Curves.easeInOut,
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
    BoxConstraints constraints,
  ) {
    return GridView.builder(
      itemCount: meeting.participants.length,
      itemBuilder: (_, index) => _buildVideoView(
        context,
        participant: meeting.participants[index],
        callState: callState,
        avatarSize: SizerUtil.isDesktop ? 50.sp : 35.sp,
      ),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
        itemCount:
            _gridCount(meeting.participants.length, constraints.maxWidth) < 2 &&
                    SizerUtil.isDesktop
                ? 2
                : meeting.participants.length,
        crossAxisCount: SizerUtil.isDesktop
            ? _gridCount(meeting.participants.length, constraints.maxWidth)
            : 2,
        mainAxisSpacing: 6.sp,
        crossAxisSpacing: 6.sp,
        childAspectRatio: SizerUtil.isDesktop
            ? (16 / 9)
            : (meeting.participants.length < 6 ? 0.6 : 1),
      ),
    );
  }

  Widget _buildVideoView(
    BuildContext context, {
    required Participant participant,
    required CallState? callState,
    double? width,
    double avatarSize = 35,
    BorderRadius? radius,
  }) {
    return MeetView(
      participant: participant,
      callState: callState,
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
