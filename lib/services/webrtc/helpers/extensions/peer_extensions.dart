// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Project imports:
import 'package:waterbus/services/webrtc/helpers/stats/webrtc_stats.dart';

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

  void statistics() {
    final WebRTCStatsUtility stats = WebRTCStatsUtility(this);

    onIceConnectionState = (state) {
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
          stats.start();
          break;
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          stats.stop();
          break;
        default:
          break;
      }
    };
  }
}
