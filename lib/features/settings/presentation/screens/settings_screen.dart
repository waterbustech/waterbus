// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/themes/theme_services.dart';
import 'package:waterbus/core/lang/language_service.dart';
import 'package:waterbus/core/lang/localization.dart';
import 'package:waterbus/features/systems/data/datasources/systems_local_datasource.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

// Project imports:
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/video_quality_bottom_sheet.dart';
import 'package:waterbus/features/systems/bloc/themes/theme_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  CallSetting _settings = CallSetting();
  String _currentLanguage = 'vi';
  bool isDarkTheme = true;

  @override
  void initState() {
    super.initState();
    _settings = AppBloc.meetingBloc.callSetting.copyWith();
    _currentLanguage = SystemLocalDataSourceImpl().getLocale;
    isDarkTheme = ThemeService().getThemeMode() == ThemeMode.dark;
  }

  void _handleSaveLanguage({required String language}) {
    if (LanguageService().getIsLanguage(language)) return;

    setState(() {
      _currentLanguage = language;
    });

    LanguageService().changeLanguage(isEnglish: _currentLanguage == 'en');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.settings.i18n,
        leading: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final User user = state is UserGetDone ? state.user : kUserDefault;

            return Align(
              alignment: Alignment.centerRight,
              child: AvatarCard(
                urlToImage: user.avatar,
                size: 24.sp,
              ),
            );
          },
        ),
        actions: [
          GestureWrapper(
            onTap: () {
              AppBloc.meetingBloc.add(
                SaveCallSettingsEvent(setting: _settings),
              );

              DeviceUtils().lightImpact();

              AppNavigator.pop();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.sp),
              _buildTitle('Displays'),
              _buildLabel('Themes'),
              SettingSwitchCard(
                label: 'Dark Theme',
                enabled: Theme.of(context).brightness == Brightness.dark,
                icon: PhosphorIcons.moon_stars_fill,
                onChanged: (isEnabled) {
                  AppBloc.themeBloc.add(
                    OnChangeTheme(
                      themeMode: Theme.of(context).brightness == Brightness.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    ),
                  );
                },
              ),
              _buildLabel('Languages'),
              SettingCheckboxCard(
                label: 'Vietnamese',
                enabled: _currentLanguage == 'vi',
                onTap: () {
                  if (_currentLanguage == 'vi') return;

                  _handleSaveLanguage(language: 'vi');
                },
              ),
              SettingCheckboxCard(
                label: 'English',
                enabled: _currentLanguage == 'en',
                hasDivider: false,
                onTap: () {
                  if (_currentLanguage == 'en') return;

                  _handleSaveLanguage(language: 'en');
                },
              ),
              _buildTitle('Call Settings'),
              _buildLabel('General'),
              SettingSwitchCard(
                label: 'Low-Bandwidth Mode',
                enabled: _settings.isLowBandwidthMode,
                hasDivider: false,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings =
                        _settings.copyWith(isLowBandwidthMode: isEnabled);
                  });
                },
              ),
              _buildLabel('Audio'),
              SettingSwitchCard(
                label: 'Start with audio muted',
                enabled: _settings.isAudioMuted,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      isAudioMuted: isEnabled,
                    );
                  });
                },
              ),
              SettingSwitchCard(
                label: 'Echo cancellation',
                enabled: _settings.echoCancellationEnabled,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      echoCancellationEnabled: isEnabled,
                    );
                  });
                },
              ),
              SettingSwitchCard(
                label: 'Noise suppression',
                enabled: _settings.noiseSuppressionEnabled,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      noiseSuppressionEnabled: isEnabled,
                    );
                  });
                },
              ),
              SettingSwitchCard(
                label: 'Automatic gain control',
                enabled: _settings.agcEnabled,
                hasDivider: false,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      agcEnabled: isEnabled,
                    );
                  });
                },
              ),
              _buildLabel('Video'),
              SettingSwitchCard(
                label: 'Start with video muted',
                enabled: _settings.isVideoMuted,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      isVideoMuted: isEnabled,
                    );
                  });
                },
              ),
              GestureWrapper(
                onTap: () {
                  showDialogWaterbus(
                    alignment: Alignment.center,
                    child: VideoQualityBottomSheet(
                      quality: _settings.videoQuality,
                      onChanged: (quality) {
                        setState(() {
                          _settings = _settings.copyWith(
                            videoQuality: quality,
                          );
                        });
                      },
                    ),
                  );
                },
                child: SettingSwitchCard(
                  label: 'Video quality',
                  enabled: true,
                  hasDivider: false,
                  value: _settings.videoQuality.label,
                  onChanged: (isEnabled) {},
                ),
              ),
              _buildLabel('Security'),
              SettingSwitchCard(
                label: 'End-to-end encryption',
                enabled: _settings.e2eeEnabled,
                icon: PhosphorIcons.shield_check_fill,
                onChanged: (isEnabled) {
                  setState(() {
                    _settings = _settings.copyWith(
                      e2eeEnabled: isEnabled,
                    );
                  });
                },
              ),
              _buildLabel('Video Layout'),
              SizedBox(height: 4.sp),
              SettingCheckboxCard(
                label: 'Grid view',
                enabled: _settings.videoLayout == VideoLayout.gridView,
                onTap: () {
                  setState(() {
                    _settings = _settings.copyWith(
                      videoLayout: VideoLayout.gridView,
                    );
                  });
                },
              ),
              SettingCheckboxCard(
                label: 'List view',
                enabled: _settings.videoLayout == VideoLayout.listView,
                hasDivider: false,
                onTap: () {
                  setState(() {
                    _settings = _settings.copyWith(
                      videoLayout: VideoLayout.listView,
                    );
                  });
                },
              ),
              _buildLabel('Preferred Codec'),
              SizedBox(height: 4.sp),
              Column(
                children: [
                  ...WebRTCCodec.values.map<Widget>(
                    (codec) => SettingCheckboxCard(
                      label: codec.codec.toUpperCase(),
                      enabled: _settings.preferedCodec == codec,
                      hasDivider: codec != WebRTCCodec.values.last,
                      onTap: () {
                        setState(() {
                          _settings = _settings.copyWith(
                            preferedCodec: codec,
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
