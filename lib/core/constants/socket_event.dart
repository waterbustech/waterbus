class SocketEvent {
  static const String joinRoomCSS = 'BROADCAST_CSS';
  static const String joinRoomSSC = 'BROADCAST_SSC';
  static const String makeSubscriberCSS = 'REQUEST_ESTABLISH_SUBSCRIBER_CSS';
  static const String answerSubscriberSSC = 'SEND_RECEIVER_SDP_SSC';
  static const String answerSubscriberCSS = 'SEND_RECEIVER_SDP_CSS';
  static const String publisherCandidateCSS = 'SEND_BROADCAST_CANDIDATE_CSS';
  static const String publisherCandidateSSC = 'SEND_BROADCAST_CANDIDATE_SSC';
  static const String subscriberCandidateCSS = 'SEND_RECEIVER_CANDIDATE_CSS';
  static const String subscriberCandidateSSC = 'SEND_RECEIVER_CANDIDATE_SSC';
  static const String newParticipantSSC = 'NEW_PARTICIPANT_SSC';
  static const String participantHasLeftSSC = 'PARTICIPANT_HAS_LEFT_SSC';
  static const String sendLeaveRoomCSS = 'LEAVE_ROOM_CSS';
  static const String setVideoEnabledCSS = "SET_VIDEO_ENABLED_CSS";
  static const String setVideoEnabledSSC = "SET_VIDEO_ENABLED_SSC";
  static const String setAudioEnabledCSS = "SET_AUDIO_ENABLED_CSS";
  static const String setAudioEnabledSSC = "SET_AUDIO_ENABLED_SSC";
}
