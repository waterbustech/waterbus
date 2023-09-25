// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

// Project imports:
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_action_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/meet_view.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        if (state is! JoinedMeeting || state.meeting == null) {
          return const SizedBox();
        }

        final Meeting meeting = state.meeting!;

        return Scaffold(
          backgroundColor: Colors.black,
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
                      icon: PhosphorIcons.microphone,
                      onTap: () {},
                    ),
                    CallActionButton(icon: PhosphorIcons.camera, onTap: () {}),
                    CallActionButton(
                      icon: PhosphorIcons.chats_teardrop,
                      onTap: () {},
                    ),
                    CallActionButton(
                      icon: PhosphorIcons.gear_six,
                      onTap: () {
                        AppNavigator.push(
                          Routes.createMeetingRoute,
                          arguments: {
                            'meeting': meeting,
                          },
                        );
                      },
                    ),
                    CallActionButton(
                      icon: PhosphorIcons.x,
                      backgroundColor: Colors.red,
                      onTap: () {
                        showDialogLoading();
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
                Expanded(
                  child: Column(
                    children: [
                      _buildMeetingView(context: context, meeting: meeting),
                      SizedBox(height: 12.sp),
                    ],
                  ),
                ),
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
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.sp),
        child: meeting.users.length > 2
            ? _buildLayoutMultipleUsers(
                context,
                meeting.copyWith(
                  users: [
                    meeting.users.first,
                    meeting.users.first,
                    meeting.users.first,
                    meeting.users.first,
                  ],
                ),
              )
            : Material(
                clipBehavior: Clip.hardEdge,
                shape: SuperellipseShape(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.sp,
                  ),
                  borderRadius: BorderRadius.circular(30.sp),
                ),
                child: _buildLayoutLess2Users(context, meeting),
              ),
      ),
    );
  }

  Widget _buildLayoutLess2Users(BuildContext context, Meeting meeting) {
    return Column(
      children: [meeting.users.first, meeting.users.first]
          .map<Widget>(
            (participant) => Expanded(
              child: MeetView(
                participant: participant,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLayoutMultipleUsers(BuildContext context, Meeting meeting) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Material(
            shape: SuperellipseShape(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.sp,
              ),
              borderRadius: BorderRadius.circular(18.sp),
            ),
            child: MeetView(
              participant: meeting.users.first,
            ),
          ),
        ),
        SizedBox(height: 6.sp),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: meeting.users.length - 1,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 6.sp),
                child: Material(
                  shape: SuperellipseShape(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.sp,
                    ),
                    borderRadius: BorderRadius.circular(18.sp),
                  ),
                  child: SizedBox(
                    width: 150.sp,
                    child: MeetView(
                      participant: meeting.users[index + 1],
                      avatarSize: 35.sp,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
