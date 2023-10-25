import 'package:sdp_transform/sdp_transform.dart' as sdp_transform;

class CodecCapability {
  CodecCapability(
    this.kind,
    this.payloads,
    this.codecs,
    this.fmtp,
    this.rtcpFb,
  ) {
    for (final element in codecs) {
      element['orign_payload'] = element['payload'];
    }
  }
  String kind;
  List<dynamic> rtcpFb;
  List<dynamic> fmtp;
  List<String> payloads;
  List<dynamic> codecs;
  bool setCodecPreferences(String kind, List<dynamic>? newCodecs) {
    if (newCodecs == null) {
      return false;
    }
    final newRtcpFb = <dynamic>[];
    final newFmtp = <dynamic>[];
    final newPayloads = <String>[];
    for (final element in newCodecs) {
      final orignPayload = element['orign_payload'] as int;
      final payload = element['payload'] as int;
      // change payload type
      if (payload != orignPayload) {
        newRtcpFb.addAll(
          rtcpFb.where((e) {
            if (e['payload'] == orignPayload) {
              e['payload'] = payload;
              return true;
            }
            return false;
          }).toList(),
        );
        newFmtp.addAll(
          fmtp.where((e) {
            if (e['payload'] == orignPayload) {
              e['payload'] = payload;
              return true;
            }
            return false;
          }).toList(),
        );
        if (payloads.contains('$orignPayload')) {
          newPayloads.add('$payload');
        }
      } else {
        newRtcpFb.addAll(rtcpFb.where((e) => e['payload'] == payload).toList());
        newFmtp.addAll(fmtp.where((e) => e['payload'] == payload).toList());
        newPayloads.addAll(payloads.where((e) => e == '$payload').toList());
      }
    }
    rtcpFb = newRtcpFb;
    fmtp = newFmtp;
    payloads = newPayloads;
    codecs = newCodecs;
    return true;
  }
}

class CodecCapabilitySelector {
  CodecCapabilitySelector(String sdp) {
    _sdp = sdp;
    _session = sdp_transform.parse(_sdp);
  }
  late String _sdp;
  late Map<String, dynamic> _session;
  Map<String, dynamic> get session => _session;
  String sdp() => sdp_transform.write(_session, null);

  CodecCapability? getCapabilities(String kind) {
    final mline = _mline(kind);
    if (mline == null) {
      return null;
    }
    final rtcpFb = mline['rtcpFb'] ?? <dynamic>[];
    final fmtp = mline['fmtp'] ?? <dynamic>[];
    final payloads = (mline['payloads'] as String).split(' ');
    final codecs = mline['rtp'] ?? <dynamic>[];
    return CodecCapability(kind, payloads, codecs, fmtp, rtcpFb);
  }

  bool setCapabilities(CodecCapability? caps) {
    if (caps == null) {
      return false;
    }
    final mline = _mline(caps.kind);
    if (mline == null) {
      return false;
    }
    mline['payloads'] = caps.payloads.join(' ');
    mline['rtp'] = caps.codecs;
    mline['fmtp'] = caps.fmtp;
    mline['rtcpFb'] = caps.rtcpFb;
    return true;
  }

  Map<String, dynamic>? _mline(String kind) {
    final mlist = _session['media'] as List<dynamic>;
    return mlist.firstWhere(
      (element) => element['type'] == kind,
      orElse: () => null,
    );
  }
}

void unAwaited(Future<void>? future) {}
