part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class RoomStarted extends RoomEvent {}

class RoomMediaStreamSetup extends RoomEvent {}

class RoomCreated extends RoomEvent {
  final String roomName;
  final String password;
  const RoomCreated({required this.roomName, required this.password});
}

class RoomUpdated extends RoomEvent {
  final String roomName;
  final String password;
  const RoomUpdated({required this.roomName, required this.password});
}

class RoomJoinedEvent extends RoomEvent {
  final Room room;
  final bool isMember;
  final String? password;
  const RoomJoinedEvent({
    required this.room,
    this.isMember = false,
    this.password,
  });
}

class RoomJoinedWithPassword extends RoomEvent {
  final String password;
  final bool isMember;
  const RoomJoinedWithPassword({
    this.password = '',
    this.isMember = false,
  });
}

class RoomInfoGot extends RoomEvent {
  final String roomCode;
  const RoomInfoGot({required this.roomCode});
}

class RoomLeft extends RoomEvent {
  final bool isReleasedWaterbusSdk;
  const RoomLeft({this.isReleasedWaterbusSdk = false});
}

class RoomDisposed extends RoomEvent {}

class RoomDialogDisplayed extends RoomEvent {
  final Room room;
  const RoomDialogDisplayed({required this.room});
}

class RoomSomeoneNewJoined extends RoomEvent {
  final Participant participant;
  const RoomSomeoneNewJoined({required this.participant});
}

class RoomSomeoneLeft extends RoomEvent {
  final String participantId;
  const RoomSomeoneLeft({required this.participantId});
}

class RoomPrepareLobby extends RoomEvent {
  final Function(Map<String, List<MediaDeviceInfo>>) handleUpdate;
  const RoomPrepareLobby(this.handleUpdate);
}

class RoomAttemptJoin extends RoomEvent {
  final String code;
  final String password;

  const RoomAttemptJoin({required this.code, required this.password});
}

class RoomSharingScreenStarted extends RoomEvent {}

class RoomSharingScreenStoped extends RoomEvent {}

class RoomAudioToggled extends RoomEvent {}

class RoomAudioDeviceToggled extends RoomEvent {
  final MediaDeviceInfo mediaDeviceInfo;

  const RoomAudioDeviceToggled({required this.mediaDeviceInfo});
}

class RoomVideoDeviceToggled extends RoomEvent {
  final MediaDeviceInfo mediaDeviceInfo;

  const RoomVideoDeviceToggled({required this.mediaDeviceInfo});
}

class RoomVideoToggled extends RoomEvent {}

class RoomHandRasingToggled extends RoomEvent {}

class RoomCallSettingsSave extends RoomEvent {
  final MediaConfig setting;
  final String? audioDeviceId;
  final String? videoDeviceId;

  const RoomCallSettingsSave({
    required this.setting,
    this.audioDeviceId,
    this.videoDeviceId,
  });
}

class RoomVirtualBackgroundApplied extends RoomEvent {
  final String? backgroundPath;
  const RoomVirtualBackgroundApplied(this.backgroundPath);
}

class RoomSubtitleToggled extends RoomEvent {
  const RoomSubtitleToggled();
}

class RoomRecordStarted extends RoomEvent {
  const RoomRecordStarted();
}

class RoomRecordStoped extends RoomEvent {
  const RoomRecordStoped();
}

class RoomDisplayRefreshed extends RoomEvent {}
