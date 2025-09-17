part of 'room_bloc.dart';

abstract class RoomState extends Equatable {
  final bool isSubtitleEnabled;
  final Stream<String>? subtitleStream;
  final Room? room;
  final ParticipantInfo? participant;
  final sdk.RoomState? roomState;
  final MediaConfig? mediaConfig;
  final bool isRecording;

  const RoomState({
    this.isSubtitleEnabled = false,
    this.isRecording = false,
    this.subtitleStream,
    this.room,
    this.participant,
    this.roomState,
    this.mediaConfig,
  });

  @override
  List<Object?> get props => [
        isSubtitleEnabled,
        subtitleStream,
        room,
        participant,
        roomState,
        mediaConfig,
        identityHashCode(this),
      ];
}

class RoomInitial extends RoomState {
  const RoomInitial({super.mediaConfig});
}

class RoomPreJoin extends RoomState {
  const RoomPreJoin({
    required super.room,
    required super.participant,
    required super.roomState,
    required super.mediaConfig,
  });
}

class RoomJoined extends RoomState {
  const RoomJoined({
    required super.isSubtitleEnabled,
    required super.subtitleStream,
    required super.room,
    required super.participant,
    required super.roomState,
    required super.mediaConfig,
    required super.isRecording,
  });
}
