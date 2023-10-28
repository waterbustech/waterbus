part of 'meeting_bloc.dart';

abstract class MeetingState extends Equatable {
  const MeetingState({
    this.meeting,
    this.participant,
    this.callState,
    this.callSetting,
  });

  final Meeting? meeting;
  final Participant? participant;
  final CallState? callState;
  final CallSetting? callSetting;

  @override
  List<Object?> get props => [
        meeting,
        participant,
        callState,
        callSetting,
        identityHashCode(this),
      ];
}

class MeetingInitial extends MeetingState {
  const MeetingInitial({super.callSetting});
}

class PreJoinMeeting extends MeetingState {
  const PreJoinMeeting({
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.callSetting,
  });
}

class JoinedMeeting extends MeetingState {
  const JoinedMeeting({
    required super.meeting,
    required super.participant,
    required super.callState,
    required super.callSetting,
  });
}
