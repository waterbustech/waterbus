part of 'meeting_bloc.dart';

sealed class MeetingEvent extends Equatable {
  const MeetingEvent();

  @override
  List<Object> get props => [];
}

class MeetingStarted extends MeetingEvent {}

class PrepareMediaStreamEvent extends MeetingEvent {}

class MeetingCreate extends MeetingEvent {
  final String roomName;
  final String password;
  const MeetingCreate({required this.roomName, required this.password});
}

class MeetingUpdate extends MeetingEvent {
  final String roomName;
  final String password;
  const MeetingUpdate({required this.roomName, required this.password});
}

class MeetingJoin extends MeetingEvent {
  final Meeting meeting;
  const MeetingJoin({required this.meeting});
}

class MeetingJoinWithPassword extends MeetingEvent {
  final String password;
  final bool isMember;
  const MeetingJoinWithPassword({
    this.password = '',
    this.isMember = false,
  });
}

class MeetingGetInfo extends MeetingEvent {
  final int roomCode;
  const MeetingGetInfo({required this.roomCode});
}

class MeetingLeave extends MeetingEvent {
  final bool isReleasedWaterbusSdk;
  const MeetingLeave({this.isReleasedWaterbusSdk = false});
}

class MeetingDispose extends MeetingEvent {}

class MeetingDisplayDialog extends MeetingEvent {
  final Meeting meeting;
  const MeetingDisplayDialog({required this.meeting});
}

class MeetingSomeoneNewJoined extends MeetingEvent {
  final Participant participant;
  const MeetingSomeoneNewJoined({required this.participant});
}

class MeetingSomeoneLeft extends MeetingEvent {
  final String participantId;
  const MeetingSomeoneLeft({required this.participantId});
}

class MeetingStartSharingScreen extends MeetingEvent {}

class MeetingStopSharingScreen extends MeetingEvent {}

class MeetingToggleAudio extends MeetingEvent {}

class MeetingToggleVideo extends MeetingEvent {}

class MeetingToggleHandRasing extends MeetingEvent {}

class MeetingSaveCallSettings extends MeetingEvent {
  final CallSetting setting;
  const MeetingSaveCallSettings({required this.setting});
}

class MeetingApplyVirtualBackground extends MeetingEvent {
  final String? backgroundPath;
  const MeetingApplyVirtualBackground(this.backgroundPath);
}

class MeetingToggleSubtitle extends MeetingEvent {
  const MeetingToggleSubtitle();
}

class MeetingStartRecord extends MeetingEvent {
  const MeetingStartRecord();
}

class MeetingStopRecord extends MeetingEvent {
  const MeetingStopRecord();
}

class MeetingRefreshDisplay extends MeetingEvent {}
