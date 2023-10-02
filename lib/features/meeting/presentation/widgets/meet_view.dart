// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:waterbus/features/meeting/domain/entities/call_state.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/gen/assets.gen.dart';

class MeetView extends StatelessWidget {
  final EdgeInsets? margin;
  final Participant participant;
  final double avatarSize;
  final CallState? callState;
  const MeetView({
    super.key,
    required this.participant,
    this.avatarSize = 80.0,
    this.margin,
    required this.callState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Stack(
        children: [
          videoRenderer != null
              ? RTCVideoView(
                  videoRenderer!,
                  key: videoRenderer!.textureId == null
                      ? null
                      : Key(videoRenderer!.textureId!.toString()),
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  mirror: true,
                  filterQuality: FilterQuality.none,
                )
              : Container(
                  alignment: Alignment.center,
                  child: participant.user.avatar == null
                      ? Material(
                          shape: SuperellipseShape(
                            borderRadius: BorderRadius.circular(18.sp),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.5),
                              width: .5,
                            ),
                          ),
                          child: Image.asset(
                            Assets.images.imgAppLogo.path,
                            width: avatarSize,
                            height: avatarSize,
                          ),
                        )
                      : AvatarCard(
                          urlToImage: participant.user.avatar!,
                          size: avatarSize,
                        ),
                ),
          Positioned(
            left: 10.sp,
            bottom: 10.sp,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.sp,
                vertical: 8.sp,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                color: Colors.black.withOpacity(.3),
              ),
              alignment: Alignment.center,
              child: Text(
                participant.user.fullName,
                style: TextStyle(
                  color: participant.role == MeetingRole.host
                      ? Colors.yellow
                      : Colors.white,
                  fontSize: avatarSize / 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  RTCVideoRenderer? get videoRenderer {
    if (callState != null) {
      if (participant.isMe) {
        return callState!.localRenderer;
      } else {
        return callState!.remoteRenderers[participant.id.toString()];
      }
    }

    return null;
  }
}
