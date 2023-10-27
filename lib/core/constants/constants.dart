// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';

const User userDefault = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.tech',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);

const Map<String, dynamic> configurationWebRTC = {
  'iceServers': [
    {
      "urls": "stun:149.28.156.10:3478",
      "username": "waterbus",
      "credential": "lambiengcode",
    },
    {
      "urls": "turn:149.28.156.10:3478?transport=udp",
      "username": "waterbus",
      "credential": "lambiengcode",
    }
  ],
  'iceTransportPolicy': 'all',
  'bundlePolicy': 'max-bundle',
  'rtcpMuxPolicy': 'require',
  'sdpSemantics': 'unified-plan',
};

const Map<String, dynamic> offerPublisherSdpConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};

const Map<String, dynamic> offerSubscriberSdpConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true,
  },
  'optional': [],
};
