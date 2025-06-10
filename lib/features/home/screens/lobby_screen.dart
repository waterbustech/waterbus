import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/drop_down/drop_down_button.dart';
import 'package:waterbus/features/conversation/xmodels/string_extension.dart';
import 'package:waterbus/features/home/widgets/device_selector.dart';
import 'package:waterbus/features/home/widgets/join_room_actions.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/preview_camera_card.dart';

class LobbyScreen extends StatefulWidget {
  final Room room;
  final bool isMember;
  final Map<String, List<MediaDeviceInfo>>? audioInputResponse;

  const LobbyScreen({
    super.key,
    required this.room,
    required this.isMember,
    required this.audioInputResponse,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final List<MediaDeviceInfo> _audioInputs = [];
  final List<MediaDeviceInfo> _audioOutputs = [];
  final List<MediaDeviceInfo> _videoInputs = [];

  MediaDeviceInfo? _audioInput;
  MediaDeviceInfo? _audioOutput;
  MediaDeviceInfo? _videoInput;
  @override
  void initState() {
    super.initState();

    _audioInputs.addAll(widget.audioInputResponse?['audioinput'] ?? []);
    _audioOutputs.addAll(widget.audioInputResponse?['audiooutput'] ?? []);
    _videoInputs.addAll(widget.audioInputResponse?['videoinput'] ?? []);

    _audioInput = _audioInputs.firstOrNull;
    _audioOutput = _audioOutputs.firstOrNull;
    _videoInput = _videoInputs.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final double previewCameraWidth = SizerUtil.isDesktop ? 52.w : 60.w;
    final double previewCameraHeight = SizerUtil.isDesktop
        ? previewCameraWidth / 16 * 9
        : previewCameraWidth / 3 * 4;

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizerUtil.isDesktop ? 8.w : 12.sp),
        child: Center(
          child: SingleChildScrollView(
            physics:
                SizerUtil.isDesktop ? NeverScrollableScrollPhysics() : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: SizerUtil.isDesktop ? 0 : 50.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PreviewCameraCard(
                      height: previewCameraHeight,
                      width: previewCameraWidth,
                    ),
                    if (SizerUtil.isDesktop)
                      Expanded(
                        child: JoinRoomActions(
                          room: widget.room,
                          isMember: widget.isMember,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 18.sp),
                if (SizerUtil.isDesktop)
                  Row(
                    children: [
                      if (_audioInputs.isNotEmpty)
                        _mediaDeviceButton(
                          icon: PhosphorIcons.microphone(),
                          currentData: _audioInput!,
                          context: context,
                          onChanged: (val) {
                            if (val == null) return;

                            setState(() {
                              _audioInput = val;
                            });

                            AppBloc.roomBloc.add(
                              RoomAudioDeviceToggled(mediaDeviceInfo: val),
                            );
                          },
                          mediaDeviceInfos: _audioInputs,
                        ),
                      if (_audioOutputs.isNotEmpty)
                        _mediaDeviceButton(
                          icon: PhosphorIcons.speakerHigh(),
                          currentData: _audioOutput!,
                          context: context,
                          onChanged: (val) {
                            setState(() {
                              _audioOutput = val;
                            });
                          },
                          mediaDeviceInfos: _audioOutputs,
                        ),
                      if (_videoInputs.isNotEmpty)
                        _mediaDeviceButton(
                          icon: PhosphorIcons.videoCamera(),
                          currentData: _videoInput!,
                          context: context,
                          onChanged: (val) {
                            if (val == null) return;

                            setState(() {
                              _videoInput = val;
                            });

                            AppBloc.roomBloc.add(
                              RoomVideoDeviceToggled(mediaDeviceInfo: val),
                            );
                          },
                          mediaDeviceInfos: _videoInputs,
                        ),
                    ],
                  ),
                if (SizerUtil.isMobile)
                  Padding(
                    padding: EdgeInsets.only(top: 20.sp, bottom: 25.sp),
                    child: JoinRoomActions(
                      room: widget.room,
                      isMember: widget.isMember,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _mediaDeviceButton({
    required BuildContext context,
    required List<MediaDeviceInfo> mediaDeviceInfos,
    void Function(MediaDeviceInfo?)? onChanged,
    required MediaDeviceInfo currentData,
    required IconData icon,
  }) {
    return Container(
      width: SizerUtil.isDesktop ? 15.w : 100.w,
      padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 6.sp),
      child: showDropdownButton<MediaDeviceInfo>(
        data: mediaDeviceInfos,
        onChanged: onChanged,
        currentData: currentData,
        customButton: DeviceSelector(
          icon: icon,
          text: currentData.label.capitalize,
        ),
        items: mediaDeviceInfos
            .map(
              (item) => DropdownMenuItem<MediaDeviceInfo>(
                value: item,
                child: Text(
                  item.label.capitalize,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
