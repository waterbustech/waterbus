import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/device_utils.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_done.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/settings/presentation/widgets/label_widget.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/video_quality_bottom_sheet.dart';

class CallSettingsScreen extends StatefulWidget {
  final bool isInRoom;
  final bool isSettingDesktop;
  const CallSettingsScreen({
    super.key,
    this.isSettingDesktop = false,
    required this.isInRoom,
  });

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<CallSettingsScreen> {
  MediaConfig _config = MediaConfig();

  @override
  void initState() {
    super.initState();
    _config = AppBloc.roomBloc.mediaConfig.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: appBarTitleBack(
        context,
        title: Strings.callSettings.i18n,
        leadingWidth: 60.sp,
        leading: widget.isSettingDesktop
            ? const SizedBox()
            : GestureWrapper(
                onTap: () {
                  AppRouter.pop();
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
              AppBloc.roomBloc.add(
                RoomCallSettingsSave(setting: _config),
              );

              if (AppRouter.canPop) {
                DeviceUtils().lightImpact();

                AppRouter.pop();
              } else {
                showDialogDone(text: Strings.saved.i18n);
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(12.sp)
                  .add(EdgeInsets.only(right: context.isDesktop ? 12.sp : 0)),
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
                  LabelWidget(label: Strings.general.i18n),
                  SettingSwitchCard(
                    label: Strings.lowBandwidthMode.i18n,
                    enabled: _config.audioConfig.isLowBandwidthMode,
                    hasDivider: false,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          audioConfig: _config.audioConfig
                              .copyWith(isLowBandwidthMode: isEnabled),
                        );
                      });
                    },
                  ),
                  LabelWidget(label: Strings.audio.i18n),
                  SettingSwitchCard(
                    label: Strings.startWithAudioMuted.i18n,
                    enabled: _config.audioConfig.isAudioMuted,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          audioConfig: _config.audioConfig
                              .copyWith(isAudioMuted: isEnabled),
                        );
                      });
                    },
                  ),
                  SettingSwitchCard(
                    label: Strings.echoCancellation.i18n,
                    enabled: _config.audioConfig.echoCancellationEnabled,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          audioConfig: _config.audioConfig
                              .copyWith(echoCancellationEnabled: isEnabled),
                        );
                      });
                    },
                  ),
                  SettingSwitchCard(
                    label: Strings.noiseSuppression.i18n,
                    enabled: _config.audioConfig.noiseSuppressionEnabled,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          audioConfig: _config.audioConfig
                              .copyWith(noiseSuppressionEnabled: isEnabled),
                        );
                      });
                    },
                  ),
                  SettingSwitchCard(
                    label: Strings.automaticGainControl.i18n,
                    enabled: _config.audioConfig.agcEnabled,
                    hasDivider: false,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          audioConfig: _config.audioConfig
                              .copyWith(agcEnabled: isEnabled),
                        );
                      });
                    },
                  ),
                  LabelWidget(label: Strings.video.i18n),
                  SettingSwitchCard(
                    label: Strings.startWithVideoMuted.i18n,
                    enabled: _config.videoConfig.isVideoMuted,
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          videoConfig: _config.videoConfig
                              .copyWith(isVideoMuted: isEnabled),
                        );
                      });
                    },
                  ),
                  GestureWrapper(
                    onTap: () {
                      showDialogWaterbus(
                        alignment: Alignment.center,
                        child: VideoQualityBottomSheet(
                          quality: _config.videoConfig.videoQuality,
                          onChanged: (quality) {
                            setState(() {
                              _config = _config.copyWith(
                                videoConfig: _config.videoConfig
                                    .copyWith(videoQuality: quality),
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
                      value: _config.videoConfig.videoQuality.name,
                      onChanged: (isEnabled) {},
                    ),
                  ),
                  LabelWidget(label: Strings.security.i18n),
                  SettingSwitchCard(
                    label: Strings.endToEndEncryption.i18n,
                    enabled: _config.e2eeEnabled,
                    readonly: widget.isInRoom,
                    icon: PhosphorIcons.shieldCheck(PhosphorIconsStyle.fill),
                    onChanged: (isEnabled) {
                      setState(() {
                        _config = _config.copyWith(
                          e2eeEnabled: isEnabled,
                        );
                      });
                    },
                  ),
                  LabelWidget(label: Strings.preferredCodec.i18n),
                  SizedBox(height: 4.sp),
                  Column(
                    children: [
                      ...RTCVideoCodec.values.map<Widget>(
                        (codec) => SettingCheckboxCard(
                          label: codec.codec.toUpperCase(),
                          enabled: _config.videoConfig.preferedCodec == codec,
                          hasDivider: codec != RTCVideoCodec.values.last,
                          onTap: () {
                            setState(() {
                              _config = _config.copyWith(
                                videoConfig: _config.videoConfig
                                    .copyWith(preferedCodec: codec),
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
}
