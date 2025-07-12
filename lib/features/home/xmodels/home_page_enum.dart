import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/archived/presentation/screens/archived_screen.dart';
import 'package:waterbus/features/chats/presentation/screens/chats_screen.dart';
import 'package:waterbus/features/home/widgets/recent_meetings.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/notification_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';
import 'package:waterbus/gen/assets.gen.dart';

enum HomePageEnum {
  recentMeeting(Strings.recent),
  chat(Strings.chat),
  notifications(Strings.notifications),
  appearance(Strings.appearance),
  archivedChats(Strings.archivedChats),
  language(Strings.language),
  callSettings(Strings.callSettings),
  licenses(Strings.licenses);

  const HomePageEnum(this.title);

  final String title;

  Widget get screen => switch (this) {
        HomePageEnum.recentMeeting => const RecentMeetings(),
        HomePageEnum.chat => const ChatsScreen(),
        HomePageEnum.notifications => const NotificationSettingsScreen(),
        HomePageEnum.appearance => const ThemeScreen(isSettingDesktop: true),
        HomePageEnum.archivedChats => const ArchivedScreen(),
        HomePageEnum.language => const LanguageScreen(isSettingDesktop: true),
        HomePageEnum.callSettings => const CallSettingsScreen(
            isSettingDesktop: true,
            isInRoom: false,
          ),
        HomePageEnum.licenses => LicensePage(
            applicationIcon: Image.asset(
              Assets.icons.launcherIcon.path,
              height: 35.sp,
            ),
            applicationVersion: kAppVersion,
          ),
      };
}

extension HomePageEnumX on String {
  HomePageEnum get getHomePageEnum {
    return HomePageEnum.values.firstWhereOrNull((item) => item.title == this) ??
        HomePageEnum.recentMeeting;
  }
}
