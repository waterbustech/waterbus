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
  const RoomJoinedEvent({required this.room});
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
  final int roomCode;
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

class RoomSharingScreenStarted extends RoomEvent {}

class RoomSharingScreenStoped extends RoomEvent {}

class RoomAudioToggled extends RoomEvent {}

class RoomVideoToggled extends RoomEvent {}

class RoomHandRasingToggled extends RoomEvent {}

class RoomCallSettingsSave extends RoomEvent {
  final MediaConfig setting;
  const RoomCallSettingsSave({required this.setting});
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
