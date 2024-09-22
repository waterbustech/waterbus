import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/device_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_navigator_observer.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/video_quality_bottom_sheet.dart';

class CallSettingsScreen extends StatefulWidget {
  final bool isSettingDesktop;
  const CallSettingsScreen({
    super.key,
    this.isSettingDesktop = false,
  });

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<CallSettingsScreen> {
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
        title: Strings.callSettings.i18n,
        leadingWidth: 60.sp,
        leading: widget.isSettingDesktop
            ? const SizedBox()
            : GestureWrapper(
                onTap: () {
                  AppNavigator.pop();
                },
                child: Center(
                  child: Text(
                    Strings.cancel.i18n,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
              padding: EdgeInsets.all(12.sp)
                  .add(EdgeInsets.only(right: SizerUtil.isDesktop ? 12.sp : 0)),
              child: Text(
                Strings.save.i18n,
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
                  _buildLabel(Strings.general.i18n),
                  SettingSwitchCard(
                    label: Strings.lowBandwidthMode.i18n,
                    enabled: _settings.isLowBandwidthMode,
                    hasDivider: false,
                    onChanged: (isEnabled) {
                      setState(() {
                        _settings =
                            _settings.copyWith(isLowBandwidthMode: isEnabled);
                      });
                    },
                  ),
                  _buildLabel(Strings.audio.i18n),
                  SettingSwitchCard(
                    label: Strings.startWithAudioMuted.i18n,
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
                    label: Strings.echoCancellation.i18n,
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
                    label: Strings.noiseSuppression.i18n,
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
                    label: Strings.automaticGainControl.i18n,
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
                  _buildLabel(Strings.video.i18n),
                  SettingSwitchCard(
                    label: Strings.startWithVideoMuted.i18n,
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
                      label: Strings.videoQuality.i18n,
                      enabled: true,
                      hasDivider: false,
                      value: _settings.videoQuality.label.i18n,
                      onChanged: (isEnabled) {},
                    ),
                  ),
                  _buildLabel(Strings.security.i18n),
                  SettingSwitchCard(
                    label: Strings.endToEndEncryption.i18n,
                    enabled: _settings.e2eeEnabled,
                    readonly: AppNavigatorObserver.routeNames.contains(
                      Routes.meetingRoute,
                    ),
                    icon: PhosphorIcons.shield_check_fill,
                    onChanged: (isEnabled) {
                      setState(() {
                        _settings = _settings.copyWith(
                          e2eeEnabled: isEnabled,
                        );
                      });
                    },
                  ),
                  _buildLabel(Strings.preferredCodec.i18n),
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
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 12.sp).add(
        EdgeInsets.symmetric(horizontal: 12.sp),
      ),
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
