import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/settings/presentation/widgets/label_widget.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SizerUtil.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: appBarTitleBack(
        context,
        title: Strings.notifications.i18n,
        leadingWidth: 60.sp,
        isVisibleBackButton: SizerUtil.isMobile,
      ),
      body: Column(
        children: [
          divider,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.sp),
                  LabelWidget(label: Strings.inAppNotification.i18n),
                  SettingSwitchCard(
                    label: Strings.newMessage.i18n,
                    enabled: true,
                    onChanged: (isEnabled) {},
                  ),
                  SettingSwitchCard(
                    label: Strings.newInvitation.i18n,
                    enabled: true,
                    hasDivider: false,
                    onChanged: (isEnabled) {},
                  ),
                  LabelWidget(label: Strings.inMeeting.i18n),
                  SettingSwitchCard(
                    label: Strings.participantJoined.i18n,
                    enabled: true,
                    onChanged: (isEnabled) {},
                  ),
                  SettingSwitchCard(
                    label: Strings.participantLeft.i18n,
                    enabled: true,
                    onChanged: (isEnabled) {},
                  ),
                  SettingSwitchCard(
                    label: Strings.participantRaiseHand.i18n,
                    enabled: true,
                    hasDivider: false,
                    onChanged: (isEnabled) {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
