class SocketEvent {
  static const String broadcastCSS = 'BROADCAST_CSS';
  static const String broadcastSSC = 'BROADCAST_SSC';
  static const String requestEstablishSubscriberCSS =
      'REQUEST_ESTABLISH_SUBSCRIBER_CSS';
  static const String sendReceiverSdpSSC = 'SEND_RECEIVER_SDP_SSC';
  static const String sendReceiverSdpCSS = 'SEND_RECEIVER_SDP_CSS';
  static const String sendBroadcastCandidateCSS =
      'SEND_BROADCAST_CANDIDATE_CSS';
  static const String sendBroadcastCandidateSSC =
      'SEND_BROADCAST_CANDIDATE_SSC';
  static const String sendReceiverCandidateCSS = 'SEND_RECEIVER_CANDIDATE_CSS';
  static const String sendReceiverCandidateSSC = 'SEND_RECEIVER_CANDIDATE_SSC';

  static const String newParticipantSSC = 'NEW_PARTICIPANT_SSC';
  static const String participantHasLeftSSC = 'PARTICIPANT_HAS_LEFT_SSC';
  static const String sendLeaveRoomCSS = 'LEAVE_ROOM_CSS';
}
