import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/navigator/routes.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/modal/show_bottom_sheet.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/share_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/beauty_filter_widget.dart';
import 'package:waterbus/features/room/presentation/widgets/call_setting_button.dart';
import 'package:waterbus/features/room/presentation/widgets/chat_in_room.dart';
import 'package:waterbus/features/room/presentation/widgets/stats_view.dart';
import 'package:waterbus/features/settings/presentation/screens/call_settings_screen.dart';

class CallSettingsBottomSheet extends StatelessWidget {
  final Function onBeautyFiltersTapped;

  const CallSettingsBottomSheet({
    super.key,
    required this.onBeautyFiltersTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        final Room? room = state.room;
        final CallState? callState = state.callState;
        final bool isSubtitleEnabled = state.isSubtitleEnabled;
        final bool isRecording = state.isRecording;

        return Container(
          padding: EdgeInsets.only(top: 16.sp),
          width: context.isDesktop ? 350.sp : 300.sp,
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
                      AppRouter.pop();
                      if (context.isMobile) {
                        CallSettingsRoute(isInRoom: true).push(context);
                      } else {
                        showScreenAsDialog(
                          route: Routes.callSettingsRoute,
                          child: CallSettingsScreen(isInRoom: true),
                        );
                      }
                    },
                  ),
                  if (context.isMobile)
                    CallSettingButton(
                      icon: PhosphorIcons.chatTeardropText(),
                      lable: Strings.chat.i18n,
                      onTap: () {
                        if (room == null) return;

                        AppRouter.pop();

                        showDialogWaterbus(
                          child: SizedBox(
                            height: 90.h,
                            child: ChatInRoom(
                              room: room,
                              onClosePressed: () {
                                AppRouter.pop();
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
                      AppRouter.pop();

                      if (context.isDesktop) {
                        onBeautyFiltersTapped();
                      } else {
                        showBottomSheetWaterbus(
                          context: context,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            height: 80.h,
                            child: BeautyFilterWidget(
                              participant: room?.participants.firstWhere(
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
                      AppRouter.pop();

                      BackgroundGalleryRoute().push(context);
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
                      AppBloc.roomBloc.add(const RoomSubtitleToggled());
                    },
                  ),
                  if (room?.isHost ?? false)
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
                          AppBloc.roomBloc.add(const RoomRecordStoped());
                        } else {
                          AppBloc.roomBloc.add(const RoomRecordStarted());
                        }
                      },
                    ),
                  CallSettingButton(
                    icon: PhosphorIcons.chartPieSlice(),
                    lable: Strings.callStats.i18n,
                    onTap: () {
                      AppRouter.pop();

                      showDialogWaterbus(
                        alignment: Alignment.center,
                        duration: 200.milliseconds.inMilliseconds,
                        maxHeight: context.isDesktop ? 450.sp : double.infinity,
                        maxWidth: context.isDesktop ? 750.sp : null,
                        child: StatsView(
                          callState: callState,
                          participants: room?.participants ?? [],
                        ),
                      );
                    },
                  ),
                  CallSettingButton(
                    icon: PhosphorIcons.shareFat(),
                    lable: Strings.shareLink.i18n,
                    onTap: () async {
                      await ShareUtils().share(
                        link: room?.inviteLink ?? '',
                        description: room?.title,
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
