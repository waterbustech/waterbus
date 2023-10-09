// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';

const User defaultUser = User(
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
  'sdpSemantics': 'unified-plan',
};

const Map<String, dynamic> defaultMediaConstraints = {
  'audio': {
    'sampleRate': '48000',
    'sampleSize': '16',
    'channelCount': '1',
    'mandatory': {
      'googEchoCancellation': 'true',
      'googEchoCancellation2': 'true',
      'googNoiseSuppression': 'true',
      'googNoiseSuppression2': 'true',
      'googAutoGainControl': 'true',
      'googAutoGainControl2': 'true',
      'googDAEchoCancellation': 'true',
      'googTypingNoiseDetection': 'true',
      'googAudioMirroring': 'false',
      'googHighpassFilter': 'true',
    },
    'optional': [],
  },
  'video': {
    'mandatory': {
      'minHeight': '360',
      'minWidth': '480',
      'minFrameRate': '15',
      'frameRate': '15',
      'height': '360',
      'width': '480',
    },
    'facingMode': 'user',
    'optional': [],
  },
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
