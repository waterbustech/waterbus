import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/features/meeting/presentation/widgets/chat_in_meeting.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extensions.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/helpers/share_utils.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_model_x.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/meeting/presentation/widgets/call_setting_button.dart';
import 'package:waterbus/features/meeting/presentation/widgets/stats_view.dart';

class CallSettingsBottomSheet extends StatelessWidget {
  final Function onBeautyFiltersTapped;

  const CallSettingsBottomSheet({
    super.key,
    required this.onBeautyFiltersTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetingBloc, MeetingState>(
      builder: (context, state) {
        final Meeting? meeting = state.meeting;
        final CallState? callState = state.callState;
        final bool isSubtitleEnabled = state.isSubtitleEnabled;
        final bool isRecording = state.isRecording;

        return Container(
          padding: EdgeInsets.only(top: 16.sp),
          width: SizerUtil.isDesktop ? 350.sp : 300.sp,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                children: [
                  CallSettingButton(
                    icon: PhosphorIcons.gearSix(),
                    lable: Strings.settings.i18n,
                    onTap: () {
                      AppNavigator.pop();

                      AppNavigator().push(Routes.settingsCallRoute);
                    },
                  ),
                  if (SizerUtil.isMobile)
                    CallSettingButton(
                      icon: PhosphorIcons.chatTeardropText(),
                      lable: Strings.chat.i18n,
                      onTap: () {
                        if (meeting == null) return;

                        AppNavigator.pop();

                        showDialogWaterbus(
                          child: SizedBox(
                            height: 90.h,
                            child: ChatInMeeting(
                              meeting: meeting,
                              onClosePressed: () {
                                AppNavigator.pop();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  CallSettingButton(
                    icon: PhosphorIcons.fire(),
                    lable: Strings.beautyFilters.i18n,
                    onTap: () {
                      AppNavigator.pop();

                      if (SizerUtil.isDesktop) {
                        onBeautyFiltersTapped();
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            height: 80.h,
                            child: BeautyFilterWidget(
                              participant: meeting?.participants.firstWhere(
                                (participant) => participant.isMe,
                              ),
                              callState: callState,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  CallSettingButton(
                    icon: PhosphorIcons.selectionBackground(),
                    lable: Strings.virtualBackground.i18n,
                    onTap: () {
                      AppNavigator.pop();

                      AppNavigator().push(Routes.backgroundGallery);
                    },
                  ),
                  CallSettingButton(
                    icon: PhosphorIcons.subtitles(
                      isSubtitleEnabled
                          ? PhosphorIconsStyle.fill
                          : PhosphorIconsStyle.regular,
                    ),
                    lable: Strings.subtitle.i18n,
                    color: isSubtitleEnabled
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    onTap: () {
                      AppBloc.meetingBloc.add(const ToggleSubtitleEvent());
                    },
                  ),
                  if (meeting?.isHost ?? false)
                    CallSettingButton(
                      icon: PhosphorIcons.record(
                        isRecording
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                      lable: Strings.record.i18n,
                      color: isRecording ? Colors.redAccent : null,
                      onTap: () {
                        if (isRecording) {
                          AppBloc.meetingBloc.add(const StopRecordEvent());
                        } else {
                          AppBloc.meetingBloc.add(const StartRecordEvent());
                        }
                      },
                    ),
                  CallSettingButton(
                    icon: PhosphorIcons.chartPieSlice(),
                    lable: Strings.callStats.i18n,
                    onTap: () {
                      AppNavigator.pop();

                      showDialogWaterbus(
                        alignment: Alignment.center,
                        duration: 200.milliseconds.inMilliseconds,
                        maxHeight:
                            SizerUtil.isDesktop ? 450.sp : double.infinity,
                        maxWidth: SizerUtil.isDesktop ? 700.sp : null,
                        child: const StatsView(),
                      );
                    },
                  ),
                  CallSettingButton(
                    icon: PhosphorIcons.shareFat(),
                    lable: Strings.shareLink.i18n,
                    onTap: () async {
                      await ShareUtils().share(
                        link: meeting?.inviteLink ?? '',
                        description: meeting?.title,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
