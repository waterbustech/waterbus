import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/preview_action_button.dart';

class PreviewCameraCard extends StatelessWidget {
  final double? height;
  final double? width;
  const PreviewCameraCard({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        final ParticipantMediaState? participant =
            state.callState?.mParticipant;

        // Return skeleton
        if (participant == null) {
          return Material(
            clipBehavior: Clip.hardEdge,
            shape: SuperellipseShape(
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Container(
              width: width ?? 265.sp,
              height: height ?? 200.sp,
              color: Colors.black,
            ),
          );
        }

        return Stack(
          children: [
            Material(
              clipBehavior: Clip.hardEdge,
              shape: SuperellipseShape(
                borderRadius: BorderRadius.circular(30.sp),
              ),
              child: Container(
                width: width ?? 265.sp,
                height: height ?? 200.sp,
                decoration: BoxDecoration(color: Colors.black),
                child: participant.isVideoEnabled
                    ? WaterbusMediaView(
                        mediaSource: participant.cameraSource!,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        mirror: true,
                      )
                    : Container(
                        padding: EdgeInsets.only(
                          bottom: context.isDesktop ? 0 : 12.sp,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Camera is off",
                          style: TextStyle(
                            color: mCL,
                            fontSize: context.isDesktop ? 16.sp : 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
            ),
            if (context.isDesktop)
              Positioned(
                bottom: 18.sp,
                right: 16.sp,
                child: PreviewActionButton(
                  shape: BoxShape.circle,
                  iconSize: context.isDesktop ? 20.sp : 16.sp,
                  boxSize: context.isDesktop ? 44.sp : 35.sp,
                  icon: PhosphorIcons.selectionBackground(),
                  iconColor: mCL,
                  onTap: () {
                    BackgroundGalleryRoute().push(context);
                  },
                ),
              ),
            Positioned(
              bottom: 18.sp,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PreviewActionButton(
                    shape: BoxShape.circle,
                    iconSize: context.isDesktop ? 20.sp : 16.sp,
                    boxSize: context.isDesktop ? 44.sp : 35.sp,
                    iconColor: mCL,
                    borderColor:
                        participant.isAudioEnabled ? null : Colors.redAccent,
                    backgroundColor:
                        participant.isAudioEnabled ? null : Colors.redAccent,
                    icon: participant.isAudioEnabled
                        ? PhosphorIcons.microphone()
                        : PhosphorIcons.microphoneSlash(),
                    onTap: () {
                      AppBloc.roomBloc.add(RoomAudioToggled());
                    },
                  ),
                  SizedBox(width: 8.sp),
                  if (context.isMobile)
                    PreviewActionButton(
                      shape: BoxShape.circle,
                      iconSize: context.isDesktop ? 20.sp : 16.sp,
                      boxSize: context.isDesktop ? 44.sp : 35.sp,
                      icon: PhosphorIcons.selectionBackground(),
                      iconColor: mCL,
                      onTap: () {
                        BackgroundGalleryRoute().push(context);
                      },
                    ),
                  SizedBox(width: context.isMobile ? 4.sp : 0),
                  PreviewActionButton(
                    iconSize: context.isDesktop ? 20.sp : 16.sp,
                    boxSize: context.isDesktop ? 44.sp : 35.sp,
                    iconColor: mCL,
                    backgroundColor:
                        participant.isVideoEnabled ? null : Colors.redAccent,
                    borderColor:
                        participant.isVideoEnabled ? null : Colors.redAccent,
                    icon: participant.isVideoEnabled
                        ? PhosphorIcons.videoCamera()
                        : PhosphorIcons.videoCameraSlash(),
                    onTap: () {
                      AppBloc.roomBloc.add(RoomVideoToggled());
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12.5.sp,
              left: 12.5.sp,
              child: Text(
                AppBloc.userBloc.user?.fullName ?? "",
                style: TextStyle(fontSize: 12.5.sp, color: mCU),
              ),
            ),
          ],
        );
      },
    );
  }
}
