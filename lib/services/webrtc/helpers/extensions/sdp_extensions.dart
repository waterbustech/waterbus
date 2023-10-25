// Package imports:
import 'package:h264_profile_level_id/h264_profile_level_id.dart';
import 'package:sdp_transform/sdp_transform.dart';

// Project imports:
import 'package:waterbus/services/webrtc/helpers/codec_selector.dart';

extension SdpX on String {
  String removeRTCPMux() {
    return replaceAll(RegExp(r'a=rtcp-mux.*\r\n'), '');
  }

  String enableAudioDTX() {
    return replaceAll(
      'a=fmtp:111 minptime=10;useinbandfec=1',
      'a=fmtp:111 minptime=10;useinbandfec=1;usedtx=1',
    );
  }

  String useH264HighLevel() {
    final profileLevelId = ProfileLevelId(
      profile: H264Utils.ProfileConstrainedBaseline,
      level: H264Utils.Level3_1,
    );
    final session = parse(this);
    session['media'][0]['profile-level-id'] = H264Utils.profileLevelIdToString(
      profileLevelId,
    );
    final newSdp = write(session, null);

    return newSdp;
  }

  String setPreferredCodec() {
    final capSel = CodecCapabilitySelector(this);

    final vcaps = capSel.getCapabilities('video');
    if (vcaps != null) {
      vcaps.codecs = vcaps.codecs
          .where((e) => (e['codec'] as String).toLowerCase() == 'h264')
          .toList();
      vcaps.setCodecPreferences('video', vcaps.codecs);
      capSel.setCapabilities(vcaps);
    }

    return capSel.sdp().useH264HighLevel();
  }

  String optimizeSdp() {
    // Split the SDP into lines.
    final List<String> lines = split('\n');

    // List of codecs you want to keep (customizable).
    final List<String> allowedCodecs = ["opus", "h264", "av1"];

    // Variable to store the optimized SDP.
    String optimizedSdp = '';

    for (String line in lines) {
      // Check if the current line contains codec information.
      if (line.contains('m=audio') || line.contains('m=video')) {
        // This is the line describing codecs.
        // Extract codecs from this line (e.g., "m=audio 12345 UDP/TLS/RTP/SAVPF 111 103 104 9 0 8").
        final List<String> codecTokens = line.split(' ');

        // Get the list of codecs listed.
        final List<String> codecs = codecTokens.sublist(3);

        // Filter the codecs you want to keep.
        final List<String> filteredCodecs =
            codecs.where((codec) => allowedCodecs.contains(codec)).toList();

        // Update the codec description line with the filtered codecs.
        line =
            '${codecTokens.sublist(0, 3).join(' ')} ${filteredCodecs.join(' ')}';
      }

      // Add the line to the optimized SDP.
      optimizedSdp += '$line\n';
    }

    return optimizedSdp;
  }
}
