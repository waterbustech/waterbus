import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/settings/presentation/bloc/notification_setting_bloc.dart';
import 'package:waterbus/features/settings/presentation/widgets/label_widget.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/xmodels/notification_settings.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile
          ? appBarTitleBack(
              context,
              title: Strings.notifications.i18n,
              leadingWidth: 60.sp,
              isVisibleBackButton: context.isMobile,
            )
          : null,
      body: Column(
        children: [
          divider,
          Expanded(
            child:
                BlocBuilder<NotificationSettingBloc, NotificationSettingState>(
              builder: (context, state) {
                final NotificationSettings settings =
                    state.notificationSettings;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.sp),
                      LabelWidget(label: Strings.inAppNotification.i18n),
                      SettingSwitchCard(
                        label: Strings.newMessage.i18n,
                        enabled: settings.newMessage,
                        onChanged: (isEnabled) {
                          AppBloc.notificationSettingBloc.add(
                            NotificationSettingUpdate(
                              settings: settings.copyWith(
                                newMessage: isEnabled,
                              ),
                            ),
                          );
                        },
                      ),
                      SettingSwitchCard(
                        label: Strings.newInvitation.i18n,
                        enabled: settings.newInvitation,
                        hasDivider: false,
                        onChanged: (isEnabled) {
                          AppBloc.notificationSettingBloc.add(
                            NotificationSettingUpdate(
                              settings: settings.copyWith(
                                newInvitation: isEnabled,
                              ),
                            ),
                          );
                        },
                      ),
                      LabelWidget(label: Strings.inMeeting.i18n),
                      SettingSwitchCard(
                        label: Strings.participantJoined.i18n,
                        enabled: settings.participantJoined,
                        onChanged: (isEnabled) {
                          AppBloc.notificationSettingBloc.add(
                            NotificationSettingUpdate(
                              settings: settings.copyWith(
                                participantJoined: isEnabled,
                              ),
                            ),
                          );
                        },
                      ),
                      SettingSwitchCard(
                        label: Strings.participantLeft.i18n,
                        enabled: settings.participantLeft,
                        onChanged: (isEnabled) {
                          AppBloc.notificationSettingBloc.add(
                            NotificationSettingUpdate(
                              settings: settings.copyWith(
                                participantLeft: isEnabled,
                              ),
                            ),
                          );
                        },
                      ),
                      SettingSwitchCard(
                        label: Strings.participantRaiseHand.i18n,
                        enabled: settings.participantRaiseHand,
                        hasDivider: false,
                        onChanged: (isEnabled) {
                          AppBloc.notificationSettingBloc.add(
                            NotificationSettingUpdate(
                              settings: settings.copyWith(
                                participantRaiseHand: isEnabled,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
