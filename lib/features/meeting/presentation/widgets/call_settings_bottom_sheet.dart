// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/helpers/share_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_setting_button.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

class CallSettingsBottomSheet extends StatelessWidget {
  const CallSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        final Meeting meeting = state.meeting!;
        final CallState? callState = state.callState;

        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 25.sp,
          ),
          width: 100.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Row(
                  children: [
                    AvatarCard(
                      urlToImage: AppBloc.userBloc.user?.avatar,
                      size: 25.sp,
                    ),
                    SizedBox(width: 8.sp),
                    Text(
                      AppBloc.userBloc.user?.fullName ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.sp),
              const Divider(),
              CallSettingButton(
                visible: meeting.isHost,
                icon: PhosphorIcons.sliders_horizontal,
                lable: 'Edit Room',
                onTap: () {
                  AppNavigator.push(
                    Routes.createMeetingRoute,
                    arguments: {
                      'meeting': meeting,
                    },
                  );
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.phone,
                lable: 'Call Settings',
                onTap: () {
                  AppNavigator.pop();

                  AppNavigator.push(Routes.settingsRoute);
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.chat_teardrop_text,
                lable: 'Discussion',
                onTap: () {},
              ),
              CallSettingButton(
                visible: WebRTC.platformIsIOS,
                icon: PhosphorIcons.magic_wand,
                lable: 'Beauty Filters',
                onTap: () {
                  AppNavigator.pop();

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SizedBox(
                      width: double.infinity,
                      height: 80.h,
                      child: BeautyFilterWidget(
                        participant: meeting.participants.firstWhere(
                          (participant) => participant.isMe,
                        ),
                        callState: callState,
                      ),
                    ),
                  );
                },
              ),
              CallSettingButton(
                visible: !kIsWeb,
                icon: PhosphorIcons.selection_background,
                lable: 'Virtual Background',
                onTap: () {
                  AppNavigator.pop();

                  AppNavigator.push(Routes.backgroundGallery);
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.chart_line,
                lable: 'Speaker Stats',
                onTap: () {},
              ),
              CallSettingButton(
                hasDivider: false,
                icon: PhosphorIcons.export,
                lable: 'Share room',
                onTap: () async {
                  await ShareUtils().share(
                    link: meeting.inviteLink,
                    description: meeting.title,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
