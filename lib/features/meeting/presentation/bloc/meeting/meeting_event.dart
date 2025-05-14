part of 'meeting_bloc.dart';

sealed class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object> get props => [];
}

class MeetingStarted extends MeetingEvent {}

class MeetingMediaStreamSetup extends MeetingEvent {}

class MeetingCreated extends MeetingEvent {
  final String roomName;
  final String password;
  const MeetingCreated({required this.roomName, required this.password});
}

class MeetingUpdated extends MeetingEvent {
  final String roomName;
  final String password;
  const MeetingUpdated({required this.roomName, required this.password});
}

class MeetingJoinedEvent extends MeetingEvent {
  final Meeting meeting;
  const MeetingJoinedEvent({required this.meeting});
}

class MeetingJoinedWithPassword extends MeetingEvent {
  final String password;
  final bool isMember;
  const MeetingJoinedWithPassword({
    this.password = '',
    this.isMember = false,
  });
}

class MeetingInfoGot extends MeetingEvent {
  final int roomCode;
  const MeetingInfoGot({required this.roomCode});
}

class MeetingLeft extends MeetingEvent {
  final bool isReleasedWaterbusSdk;
  const MeetingLeft({this.isReleasedWaterbusSdk = false});
}

class MeetingDisposed extends MeetingEvent {}

class MeetingDialogDisplayed extends MeetingEvent {
  final Meeting meeting;
  const MeetingDialogDisplayed({required this.meeting});
}

class MeetingSomeoneNewJoined extends MeetingEvent {
  final Participant participant;
  const MeetingSomeoneNewJoined({required this.participant});
}

class MeetingSomeoneLeft extends MeetingEvent {
  final String participantId;
  const MeetingSomeoneLeft({required this.participantId});
}

class MeetingSharingScreenStarted extends MeetingEvent {}

class MeetingSharingScreenStoped extends MeetingEvent {}

class MeetingAudioToggled extends MeetingEvent {}

class MeetingVideoToggled extends MeetingEvent {}

class MeetingHandRasingToggled extends MeetingEvent {}

class MeetingCallSettingsSave extends MeetingEvent {
  final MediaConfig setting;
  const MeetingCallSettingsSave({required this.setting});
}

class MeetingVirtualBackgroundApplied extends MeetingEvent {
  final String? backgroundPath;
  const MeetingVirtualBackgroundApplied(this.backgroundPath);
}

class MeetingSubtitleToggled extends MeetingEvent {
  const MeetingSubtitleToggled();
}

class MeetingRecordStarted extends MeetingEvent {
  const MeetingRecordStarted();
}

class MeetingRecordStoped extends MeetingEvent {
  const MeetingRecordStoped();
}

class MeetingDisplayRefreshed extends MeetingEvent {}
