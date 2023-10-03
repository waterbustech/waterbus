// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

const int delay300ms = 300;
const int delay500ms = 500;

const int connectTimeOut = 10000;
const int receiveTimeOut = 10000;

const unlimited = 99999;

Widget dividerContainer = Container(
  color: colorBlack1,
  height: 6.sp,
);

Divider divider = Divider(
  height: 1.sp,
  color: colorGreyWhite,
);

const User defaultUser = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.io',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);

const Map<String, dynamic> configurationWebRTC = {
  'iceServers': [
    {
      "urls": ["stun:ss-turn1.xirsys.com"],
    },
    {
      "username":
          "4kHBzu7DVCQm2uxo8Gk_eLvg8Wzqcvdpq3y9OF38MRLJxuH8SVqKDj0CgjQCya_QAAAAAGN9laxkaW5odHJvbmcwNTAz",
      "credential": "468a04dc-6ae0-11ed-9d14-0242ac140004",
      "urls": [
        "turn:ss-turn1.xirsys.com:80?transport=udp",
        "turn:ss-turn1.xirsys.com:3478?transport=udp",
        "turn:ss-turn1.xirsys.com:80?transport=tcp",
        "turn:ss-turn1.xirsys.com:3478?transport=tcp",
        "turns:ss-turn1.xirsys.com:443?transport=tcp",
        "turns:ss-turn1.xirsys.com:5349?transport=tcp",
      ],
    }
  ],
  'sdpSemantics': "unified-plan",
  'iceTransportPolicy': 'relay',
};

const Map<String, dynamic> offerSdpConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true,
  },
  'optional': [],
};
