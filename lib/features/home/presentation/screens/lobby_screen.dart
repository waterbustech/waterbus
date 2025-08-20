import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/drop_down/drop_down_button.dart';
import 'package:waterbus/features/conversation/domain/entities/string_extension.dart';
import 'package:waterbus/features/home/presentation/widgets/device_selector.dart';
import 'package:waterbus/features/home/presentation/widgets/join_room_actions.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/preview_camera_card.dart';

class LobbyScreen extends StatefulWidget {
  final Room? room;
  final String code;
  final bool isMember;

  const LobbyScreen({
    super.key,
    this.room,
    this.isMember = false,
    required this.code,
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

  Room? _room;

  @override
  void initState() {
    super.initState();

    _room = widget.room;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppBloc.roomBloc.add(
        RoomPrepareLobby(
          onPrepareLobby: (val, room) {
            final Map<String, List<MediaDeviceInfo>> mediaDeviceInfoList = val;

            _audioInputs.addAll(mediaDeviceInfoList['audioinput'] ?? []);
            _audioOutputs.addAll(mediaDeviceInfoList['audiooutput'] ?? []);
            _videoInputs.addAll(mediaDeviceInfoList['videoinput'] ?? []);

            _audioInput = _audioInputs.firstOrNull;
            _audioOutput = _audioOutputs.firstOrNull;
            _videoInput = _videoInputs.firstOrNull;

            _room ??= room;

            setState(() {});
          },
          code: widget.room != null ? null : widget.code,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double previewCameraWidth = context.isDesktop ? 50.w : 60.w;

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.isDesktop ? 8.w : 12.sp),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1600.sp),
            child: SingleChildScrollView(
              physics:
                  context.isDesktop ? NeverScrollableScrollPhysics() : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: context.isDesktop ? 0 : 50.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 800.sp,
                        ),
                        width: previewCameraWidth,
                        child: AspectRatio(
                          aspectRatio: context.isDesktop ? 16 / 9 : 3 / 4,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return PreviewCameraCard(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                              );
                            },
                          ),
                        ),
                      ),
                      if (context.isDesktop && _room != null)
                        Expanded(
                          child: JoinRoomActions(
                            room: _room!,
                            isMember: widget.isMember,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 18.sp),
                  if (context.isDesktop)
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
                                RoomAudioDeviceToggled(
                                  mediaDeviceInfo: val,
                                ),
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
                                RoomVideoDeviceToggled(
                                  mediaDeviceInfo: val,
                                ),
                              );
                            },
                            mediaDeviceInfos: _videoInputs,
                          ),
                      ],
                    ),
                  if (context.isMobile && _room != null)
                    Padding(
                      padding: EdgeInsets.only(top: 20.sp, bottom: 25.sp),
                      child: JoinRoomActions(
                        room: _room!,
                        isMember: widget.isMember,
                      ),
                    ),
                ],
              ),
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
      width: context.isDesktop ? 160.sp : 100.w,
      margin: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 6.sp),
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
