// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/home/widgets/tab_options_desktop_widget.dart';
import 'package:waterbus/features/profile/presentation/screens/profile_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/app_settings.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/language_screen.dart';
import 'package:waterbus/features/settings/presentation/screens/theme_screen.dart';
import 'package:waterbus/features/settings/presentation/widgets/body_setting_screens.dart';
import 'package:waterbus/features/settings/presentation/xmodels/tab_option_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final List<TabOption> _screensOption;
  String _currentTabKey = '';

  @override
  void initState() {
    super.initState();

    _screensOption = [
      TabOption(
        key: profileTab,
        tab: ProfileScreen(
          isSettingDesktop: SizerUtil.isDesktop,
        ),
      ),
      TabOption(
        key: appearanceTab,
        tab: ThemeScreen(
          isSettingDesktop: SizerUtil.isDesktop,
        ),
      ),
      TabOption(
        key: languageTab,
        tab: LanguageScreen(
          isSettingDesktop: SizerUtil.isDesktop,
        ),
      ),
      TabOption(
        key: callAndMeetingTab,
        tab: CallSettingsScreen(
          isSettingDesktop: SizerUtil.isDesktop,
        ),
      ),
    ];
  }

  Widget _tabWidgetSelected() {
    final int indexOfTab = _screensOption.indexWhere(
      (tab) => tab.key == _currentTabKey,
    );

    if (indexOfTab == -1) return const SizedBox();

    return _screensOption[indexOfTab].tab;
  }

  void _handlePressedOption({required String key}) {
    AppNavigator().navigatorSettingPopToRoot();
    setState(() {
      _currentTabKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: SizerUtil.isDesktop ? 300.sp : 100.w,
          child: Scaffold(
            appBar: appBarTitleBack(
              context,
              title: SizerUtil.isDesktop ? Strings.settings.i18n : '',
              leading: IconButton(
                padding: EdgeInsets.only(left: 12.sp),
                onPressed: () {},
                icon: Icon(
                  PhosphorIcons.user_circle_plus,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              actions: [
                GestureWrapper(
                  onTap: () {
                    AppNavigator().push(Routes.profileRoute);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    padding: EdgeInsets.only(
                      right: SizerUtil.isDesktop ? 20.sp : 12.sp,
                    ),
                    child: Text(
                      Strings.edit.i18n,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SizerUtil.isDesktop
                ? TabOptionsDesktopWidget(
                    child: BodySettingScreens(
                      onTap: (val) {
                        _handlePressedOption(key: val);
                      },
                    ),
                  )
                : const BodySettingScreens(),
          ),
        ),
        if (SizerUtil.isDesktop)
          const VerticalDivider(
            width: .5,
            thickness: .5,
          ),
        Expanded(
          child: AppSettings(
            optionScreen: _tabWidgetSelected(),
          ),
        ),
      ],
    );
  }
}
