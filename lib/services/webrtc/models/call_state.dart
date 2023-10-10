// Flutter imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:waterbus/services/webrtc/models/participant_sfu.dart';

class CallState extends Equatable {
  final ParticipantSFU? mParticipant;
  final Map<String, ParticipantSFU> participants;
  const CallState({
    this.mParticipant,
    required this.participants,
  });

  CallState copyWith({
    ParticipantSFU? mParticipant,
    Map<String, ParticipantSFU>? participants,
  }) {
    return CallState(
      mParticipant: mParticipant ?? this.mParticipant,
      participants: participants ?? this.participants,
    );
  }

  @override
  String toString() =>
      'CallState(mParticipant: $mParticipant, participants: $participants)';

  @override
  bool operator ==(covariant CallState other) {
    if (identical(this, other)) return true;

    return other.mParticipant == mParticipant &&
        mapEquals(other.participants, participants);
  }

  @override
  int get hashCode => mParticipant.hashCode ^ participants.hashCode;

  @override
  List<Object?> get props => [mParticipant, participants];
}
