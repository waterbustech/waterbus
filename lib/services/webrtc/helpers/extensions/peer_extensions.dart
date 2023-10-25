// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

extension PeerX on RTCPeerConnection {
  void setMaxBandwidth(int? bandwidth) {
    senders.then((senders) {
      for (final sender in senders) {
        final parameters = sender.parameters;
        var encodings = parameters.encodings;

        if (encodings == null || encodings.isEmpty) {
          encodings = List.of([RTCRtpEncoding()]);
        }

        for (final encoding in encodings) {
          if (bandwidth == null || bandwidth == 0) {
            encoding.maxBitrate = null;
          } else {
            encoding.maxBitrate = bandwidth * 1000;
          }
        }

        parameters.encodings = encodings;
        sender.setParameters(parameters);
      }
    });
  }

  Future<void> setVideoCodec(int clockRate) async {
    final codecs = [
      RTCRTPCodec(
        name: 'video/H264',
        kind: 'video',
        clockRate: clockRate,
        parameters: {
          'level-asymmetry-allowed': '1',
          'packetization-mode': '1',
          'profile-level-id': '640d61',
        },
      ),
    ];

    final senders = await getSenders();
    for (final sender in senders) {
      if (sender.track?.kind == 'video') {
        final senderParameters = sender.parameters;
        senderParameters.codecs = codecs;
        sender.setParameters(senderParameters);
      }
    }
  }
}
