// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/video_quality_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  CallSetting _settings = CallSetting();

  @override
  void initState() {
    super.initState();
    _settings = AppBloc.meetingBloc.callSetting.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Settings',
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
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return VideoQualityBottomSheet(
                        quality: _settings.videoQuality,
                        onChanged: (quality) {
                          setState(() {
                            _settings = _settings.copyWith(
                              videoQuality: quality,
                            );
                          });
                        },
                      );
                    },
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
              _buildLabel('Prefered Codec'),
              SizedBox(height: 4.sp),
              ...WebRTCCodec.values.map(
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
              SizedBox(height: 10.h),
            ],
          ),
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
