import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/meeting/presentation/widgets/stats_view.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/share_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_setting_button.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

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
                lable: Strings.editMeeting.i18n,
                onTap: () {
                  AppNavigator().push(
                    Routes.createMeetingRoute,
                    arguments: {
                      'meeting': meeting,
                    },
                  );
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.phone,
                lable: Strings.callSettings.i18n,
                onTap: () {
                  AppNavigator.pop();

                  AppNavigator().push(Routes.settingsCallRoute);
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.chat_teardrop_text,
                lable: Strings.chat.i18n,
                onTap: () {},
              ),
              CallSettingButton(
                visible: WebRTC.platformIsMobile && !SizerUtil.isDesktop,
                icon: PhosphorIcons.magic_wand,
                lable: Strings.beautyFilters.i18n,
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
                icon: PhosphorIcons.selection_background,
                lable: Strings.virtualBackground.i18n,
                onTap: () {
                  AppNavigator.pop();

                  AppNavigator().push(Routes.backgroundGallery);
                },
              ),
              CallSettingButton(
                icon: PhosphorIcons.chart_line,
                lable: Strings.callStats.i18n,
                onTap: () {
                  AppNavigator.pop();

                  showDialogWaterbus(
                    duration: 200.milliseconds.inMilliseconds,
                    maxHeight: 450.sp,
                    maxWidth: 700.sp,
                    child: const StatsView(),
                  );
                },
              ),
              CallSettingButton(
                hasDivider: false,
                icon: PhosphorIcons.export,
                lable: Strings.shareLink.i18n,
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
