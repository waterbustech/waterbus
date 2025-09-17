import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_pip_mode/simple_pip.dart';
import 'package:toastification/toastification.dart';
import 'package:waterbus_sdk/core/events/waterbus_event_system.dart' as sdk;
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart' as sdk;
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/extensions/failure_x.dart';
import 'package:waterbus/core/method_channels/pip_channel.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/audio/meeting_sound.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/common/widgets/dialogs/dialog_loading.dart';
import 'package:waterbus/features/conversation/domain/entities/string_extension.dart';
import 'package:waterbus/features/room/data/datasources/media_config_data_source.dart';
import 'package:waterbus/features/room/data/datasources/room_local_data_source.dart';
import 'package:waterbus/features/room/domain/entities/room_model_x.dart';
import 'package:waterbus/features/room/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/room/presentation/widgets/screen_select_dialog.dart';

part 'room_event.dart';
part 'room_state.dart';

@injectable
class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomLocalDataSource _localDataSource;
  final MediaConfigLocalDataSource _callSettingsLocalDataSource;
  final PipChannel _pipChannel;
  final RoomSound _roomSound;
  final WaterbusSdk _waterbusSdk = WaterbusSdk.instance;

  // MARK: private
  final StreamController<String> _subtitle =
      StreamController<String>.broadcast();
  String? _currentBackground;
  bool _isSubtitleEnabled = false;
  Room? _currentRoom;
  ParticipantInfo? _mParticipant;
  MediaConfig _mediaConfig = MediaConfig();
  int? _recordId;
  final List<MediaDeviceInfo> audioInputs = [];
  final List<MediaDeviceInfo> videoInputs = [];
  final List<MediaDeviceInfo> audioOutputs = [];
  MediaDeviceInfo? audioInputSelected;
  MediaDeviceInfo? videoInputSelected;

  RoomBloc(
    this._pipChannel,
    this._roomSound,
    this._localDataSource,
    this._callSettingsLocalDataSource,
  ) : super(const RoomInitial()) {
    on<RoomEvent>(
      transformer: sequential(),
      (event, emit) async {
        if (event is RoomStarted) {
          _mediaConfig = _callSettingsLocalDataSource.getSettings();

          await _waterbusSdk.updateMediaConfig(_mediaConfig);
          _waterbusSdk.on<sdk.RoomEvent>().listen(_onRoomEventChanged);
          _waterbusSdk
              .on<sdk.ParticipantEvent>()
              .listen(_onParticipantEventChanged);
        }

        if (event is RoomCreated) {
          await _handleCreateRoom(event);
        }

        if (event is RoomUpdated) {
          await _handleUpdateRoom(event);

          if (_currentRoom != null) {
            emit(_joinedRoom);
          }
        }

        if (event is RoomJoinedEvent) {
          _currentRoom = event.room;

          final bool isJoinSucceed = await _handleJoinRoom(
            RoomJoinedWithPassword(
              isMember: event.isMember,
              password: event.password ?? '',
            ),
          );

          if (isJoinSucceed) {
            emit(_joinedRoom);
            RoomRoute(code: _currentRoom?.code ?? '').go(AppRouter.context!);

            _roomSound.playSoundJoinRoom();
          }
        }

        if (event is RoomInfoGot) {
          final Room? room =
              event.room ?? await _handleGetRoomInfo(event.roomCode ?? "");

          if (room != null) {
            _displayDialogJoinRoom(room);

            emit(_preJoinRoom);
          }
        }

        if (event is RoomLeft) {
          if (state is RoomPreJoin) {
            await _dispose();
          } else {
            await _handleLeaveRoom(event);
          }
          emit(_roomInitial);
        }

        if (event is RoomSharingScreenStarted) {
          DesktopCapturerSource? source;

          if (WebRTC.platformIsDesktop) {
            source = await showDialogWaterbus(
              alignment: Alignment.center,
              maxWidth: 400.sp,
              maxHeight: 450.sp,
              child: const ScreenSelectDialog(),
            );

            if (source == null) return;
          }

          await _waterbusSdk.startScreenSharing(source: source);
        }

        if (event is RoomSharingScreenStoped) {
          await _waterbusSdk.stopScreenSharing();
        }

        if (event is RoomVideoToggled) {
          await _waterbusSdk.toggleVideo();

          if (state is RoomJoined) {
            emit(_joinedRoom);
          } else if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }

        if (event is RoomAudioToggled) {
          await _waterbusSdk.toggleAudio();

          if (state is RoomJoined) {
            emit(_joinedRoom);
          } else if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }

        if (event is RoomAudioDeviceToggled) {
          await _waterbusSdk.changeAudioInputDevice(
            deviceId: event.mediaDeviceInfo.deviceId,
          );

          audioInputSelected = event.mediaDeviceInfo;

          if (state is RoomJoined) {
            emit(_joinedRoom);
          } else if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }

        if (event is RoomVideoDeviceToggled) {
          await _waterbusSdk.changeVideoInputDevice(
            deviceId: event.mediaDeviceInfo.deviceId,
          );

          videoInputSelected = event.mediaDeviceInfo;

          if (state is RoomJoined) {
            emit(_joinedRoom);
          } else if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }

        if (event is RoomHandRasingToggled) {
          _waterbusSdk.toggleRaiseHand();

          if (_isHandRaisingLocal) {
            _roomSound.playSoundRaiseHand();
          }

          if (state is RoomJoined) {
            emit(_joinedRoom);
          } else if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }

        if (event is RoomCallSettingsSave) {
          _callSettingsLocalDataSource.saveSettings(event.setting);

          _mediaConfig = event.setting;

          if (state is RoomJoined) {
            // Hot update settings
            return;
          }

          emit(_roomInitial);
        }

        if (event is RoomVirtualBackgroundApplied) {
          _currentBackground = event.backgroundPath;

          if (event.backgroundPath != null) {
            Future.microtask(() async {
              final ByteData bytes = await rootBundle.load(
                event.backgroundPath!,
              );
              final Uint8List backgroundBuffer = bytes.buffer.asUint8List();

              _waterbusSdk.enableVirtualBackground(
                backgroundImage: backgroundBuffer,
              );
            });
          } else {
            await _waterbusSdk.disableVirtualBackground();
          }
        }

        if (event is RoomSubtitleToggled) {
          if (state is! RoomJoined) return;

          _isSubtitleEnabled = !_isSubtitleEnabled;
          _waterbusSdk.setSubscribeSubtitle(isEnabled: _isSubtitleEnabled);
          emit(_joinedRoom);
        }

        if (event is RoomDisplayRefreshed) {
          if (state is RoomInitial) return;

          if (state is RoomPreJoin) {
            emit(_preJoinRoom);
          } else {
            emit(_joinedRoom);
          }
        }

        if (event is RoomDisposed) {
          await _dispose();
          emit(_roomInitial);
        }

        if (event is RoomSomeoneNewJoined) {
          await _handleNewParticipant(event);

          if (_currentRoom != null) {
            emit(_joinedRoom);
          }
        }

        if (event is RoomSomeoneLeft) {
          await _handleParticipantHasLeft(event);

          if (_currentRoom != null) {
            emit(_joinedRoom);
          }
        }

        if (event is RoomPrepareLobby) {
          displayLoadingLayer();
          Room? room;
          Map<String, List<MediaDeviceInfo>> mediaDeviceList = {};

          if (event.code != null) {
            room = await _handleGetRoomInfo(event.code!);

            final isOwner = room?.isOwner ?? false;

            final isPublisher =
                room?.streamingProtocol == StreamingProtocol.rtc || isOwner;

            if (isPublisher) {
              await _waterbusSdk.prepareMedia();
              mediaDeviceList = await _getAllMediaDevices();
            }
          } else {
            AppRouter.pop();
          }

          event.onPrepareLobby.call(mediaDeviceList, room);

          if (state is! RoomPreJoin) {
            emit(_preJoinRoom);
          }
        }
      },
    );
  }

  // MARK: state
  RoomInitial get _roomInitial => RoomInitial(
        mediaConfig: _mediaConfig,
      );

  RoomJoined get _joinedRoom => RoomJoined(
        isSubtitleEnabled: _isSubtitleEnabled,
        subtitleStream: _subtitle.stream,
        room: _currentRoom,
        participant: _mParticipant,
        roomState: _waterbusSdk.roomState,
        mediaConfig: _mediaConfig,
        isRecording: _recordId != null,
      );

  RoomPreJoin get _preJoinRoom => RoomPreJoin(
        room: _currentRoom,
        participant: _mParticipant,
        roomState: _waterbusSdk.roomState,
        mediaConfig: _mediaConfig,
      );

  // MARK: Private
  bool get _isHandRaisingLocal =>
      _waterbusSdk.roomState.localParticipant?.isHandRaising ?? false;

  Future<void> _handleCreateRoom(RoomCreated event) async {
    final RoomParams params = RoomParams(
      room: Room(
        title: event.roomName,
        roomType: event.roomType,
        streamingProtocol: event.streamingProtocol,
        capacity: event.capacity,
      ),
      password: event.password,
      userId: AppBloc.userBloc.user?.id,
    );

    final Result<Room> result = await _waterbusSdk.createRoom(params: params);

    AppRouter.popUntilToRoot();

    if (result.isSuccess) {
      Room room = result.value!;
      room = room.copyWith(latestJoinedAt: DateTime.now());
      _localDataSource.insertOrUpdate(room);
      AppBloc.chatBloc.add(ChatInserted(conversation: room));
      AppBloc.recentJoinedBloc.add(RecentJoinedInserted(room: room));
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<bool> _handleJoinRoom(RoomJoinedWithPassword event) async {
    final JoinRoomParams params = JoinRoomParams(
      roomId: _currentRoom!.id,
      password: event.password,
      userId: AppBloc.userBloc.user?.id,
    );

    final Result<Room> result = await _waterbusSdk.joinRoom(params: params);

    if (result.isSuccess) {
      final Room room = result.value!;
      _localDataSource.insertOrUpdate(room);

      _currentRoom = room;

      AppBloc.recentJoinedBloc.add(
        RecentJoinedInserted(room: room),
      );

      final int indexOfMyParticipant = room.participants.lastIndexWhere(
        (participant) => participant.isMe,
      );

      if (indexOfMyParticipant != -1) {
        _mParticipant = room.participants[indexOfMyParticipant];
      }

      return true;
    } else {
      result.error.messageException.showToast(ToastificationType.error);
      return false;
    }
  }

  Future<Room?> _handleGetRoomInfo(String roomCode) async {
    final Result<Room> result = await _waterbusSdk.getRoomInfo(code: roomCode);

    AppRouter.pop();

    if (result.isSuccess) {
      return result.value;
    } else {
      result.error.messageException.showToast(ToastificationType.error);
      return null;
    }
  }

  Future<void> _handleUpdateRoom(RoomUpdated event) async {
    if (_currentRoom == null) return;
    final RoomParams params = RoomParams(
      room: _currentRoom!.copyWith(title: event.roomName),
      password: event.password,
      userId: AppBloc.userBloc.user?.id,
    );

    final Result<bool> result = await _waterbusSdk.updateRoom(params: params);

    AppRouter.pop();

    if (result.isSuccess) {
      final Room room = _currentRoom!.copyWith(title: event.roomName);
      _localDataSource.insertOrUpdate(room);

      AppRouter.pop();
      AppBloc.recentJoinedBloc.add(RecentJoinedInserted(room: room));

      _currentRoom = room;
    } else {
      result.error.messageException.showToast(ToastificationType.error);
    }
  }

  Future<void> _handleLeaveRoom(RoomLeft event) async {
    if (_currentRoom == null || _mParticipant == null) return;

    final List<ParticipantInfo> participants = _currentRoom!.participants
        .where((participant) => !participant.isMe)
        .toList();

    _currentRoom = _currentRoom!.copyWith(participants: participants);

    AppBloc.recentJoinedBloc.add(
      RecentJoinedUpdated(room: _currentRoom!),
    );

    _currentRoom = null;
    _mParticipant = null;

    if (!event.isReleasedWaterbusSdk) {
      await _waterbusSdk.leaveRoom();
    }

    AppRouter.popUntilToRoot();
  }

  Future<void> _handleNewParticipant(RoomSomeoneNewJoined event) async {
    if (_currentRoom == null) return;

    final List<ParticipantInfo> participants =
        _currentRoom!.participants.map((item) => item).toList();

    final int indexOfParticipant = participants.indexWhere(
      (participant) => participant.id == event.participant.id,
    );

    if (indexOfParticipant != -1) return;

    participants.add(
      ParticipantInfo(id: event.participant.id, user: event.participant.user),
    );

    _currentRoom = _currentRoom!.copyWith(participants: participants);

    AppBloc.recentJoinedBloc.add(RecentJoinedUpdated(room: _currentRoom!));

    _roomSound.playSoundJoinRoom();
  }

  Future<void> _handleParticipantHasLeft(
    RoomSomeoneLeft event,
  ) async {
    if (_currentRoom == null) return;

    final List<ParticipantInfo> participants =
        _currentRoom!.participants.map((item) => item).toList();

    final int indexOfParticipant = participants.indexWhere(
      (participant) => participant.id == int.parse(event.participantId),
    );

    if (indexOfParticipant != -1) {
      participants.removeAt(indexOfParticipant);

      _currentRoom = _currentRoom!.copyWith(
        participants: participants,
      );

      AppBloc.recentJoinedBloc.add(
        RecentJoinedUpdated(room: _currentRoom!),
      );
    }
  }

  void _displayDialogJoinRoom(Room room) {
    final int indexOfMember = room.members.indexWhere(
      (member) => member.user.id == AppBloc.userBloc.user?.id,
    );

    LobbyRoute(code: room.code!, $extra: room, isMember: indexOfMember != -1)
        .push(AppRouter.context!);
  }

  Future<void> startPiP() async {
    if (WebRTC.platformIsDesktop || kIsWeb) return;

    if (_waterbusSdk.roomState.remoteParticipants.isEmpty) return;

    if (WebRTC.platformIsAndroid) {
      SimplePip().setAutoPipMode();
      return;
    }

    final List<MapEntry<String, RemoteParticipant>> participants =
        _waterbusSdk.roomState.remoteParticipants.entries.toList();

    participants.sort(
      (a, b) =>
          a.value.audioLevel.threshold.compareTo(b.value.audioLevel.threshold),
    );

    final RemoteParticipant remoteParticipant = participants.first.value;
    final int indexOfParticipant = _currentRoom?.participants.indexWhere(
          (part) => part.id.toString() == participants.first.key,
        ) ??
        -1;

    if (indexOfParticipant == -1) return;

    final ParticipantInfo participant =
        _currentRoom!.participants[indexOfParticipant];

    _pipChannel.startPip(
      remoteStreamId: remoteParticipant.cameraSource?.streamId ?? '',
      peerConnectionId: remoteParticipant.peerConnection.peerConnectionId,
      myAvatar: AppBloc.userBloc.user?.avatar ?? '',
      remoteAvatar: participant.user?.avatar ?? '',
      remoteName: participant.user?.fullName ?? '',
      isRemoteCameraEnable: remoteParticipant.isVideoEnabled,
    );
  }

  void _onParticipantEventChanged(sdk.ParticipantEvent event) {
    if (event is sdk.ParticipantLeft) {
      _roomSound.playSoundLeaveRoom();

      add(RoomSomeoneLeft(participantId: event.participantId));
    } else if (event is sdk.ParticipantConnectionQualityChanged ||
        event is sdk.ParticipantE2eeEnabledChanged ||
        event is sdk.ParticipantScreenSharingChanged ||
        event is sdk.ParticipantCameraTypeChanged ||
        event is sdk.ParticipantVideoEnabledChanged ||
        event is sdk.ParticipantAudioEnabledChanged) {
      add(RoomDisplayRefreshed());
    } else if (event is sdk.ParticipantHandRaiseChanged) {
      add(RoomDisplayRefreshed());
      _roomSound.playSoundRaiseHand();
    } else if (event is sdk.ParticipantJoined) {
      add(RoomSomeoneNewJoined(participant: event.participant));
    }
  }

  void _onRoomEventChanged(sdk.RoomEvent event) {
    if (event is sdk.RoomEnded) {
      if (WebRTC.platformIsAndroid) {
        SimplePip().setAutoPipMode(autoEnter: false);
      } else {
        _pipChannel.stopPip();
      }

      if (state is RoomJoined) {
        add(const RoomLeft(isReleasedWaterbusSdk: true));
      } else if (state is RoomPreJoin) {
        add(RoomDisposed());
      }
    } else {
      startPiP();

      if (event is sdk.RoomStateChanged) {
        add(RoomDisplayRefreshed());
      }
    }
  }

  Future<Map<String, List<MediaDeviceInfo>>> _getAllMediaDevices() async {
    final devices = await navigator.mediaDevices.enumerateDevices();

    audioInputs.clear();
    videoInputs.clear();
    audioOutputs.clear();

    for (final device in devices) {
      switch (device.kind) {
        case 'audioinput':
          audioInputs.add(device);
          break;
        case 'audiooutput':
          audioOutputs.add(device);

          break;
        case 'videoinput':
          videoInputs.add(device);

          break;
      }
    }

    audioInputSelected = audioInputs.firstOrNull;
    videoInputSelected = videoInputs.firstOrNull;

    return {
      'audioinput': audioInputs,
      'audiooutput': audioOutputs,
      'videoinput': videoInputs,
    };
  }

  Future<void> _dispose() async {
    await _waterbusSdk.leaveRoom();

    _currentRoom = null;
    _mParticipant = null;
    _currentBackground = null;
    _recordId = null;
    _subtitle.close();

    AppBloc.beautyFiltersBloc.add(BeautyFilterReset());
  }

  // MARK: export
  MediaConfig get mediaConfig => _mediaConfig;

  String? get currentBackground => _currentBackground;

  Room? get currentRoom => _currentRoom;
  sdk.RoomState? get roomState => _waterbusSdk.roomState;
}
