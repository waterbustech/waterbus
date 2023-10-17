import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:waterbus/services/webrtc/models/priority_rtc.dart';

/// The RTP capabilities define what mediasoup or an endpoint can receive at
/// media level.
class RtpCapabilities {
  /// Supported media and RTX codecs.
  final List<RtpCodecCapability> codecs;

  /// Supported RTP header extensions.
  final List<RtpHeaderExtension> headerExtensions;

  /// Supported FEC mechanisms.
  final List<String> fecMechanisms;

  RtpCapabilities({
    this.codecs = const [],
    this.headerExtensions = const [],
    this.fecMechanisms = const [],
  });

  RtpCapabilities.fromMap(Map data)
      : codecs = data['codecs']
            .map<RtpCodecCapability>(
              (codec) => RtpCodecCapability.fromMap(codec),
            )
            .toList(),
        headerExtensions = (data['headerExtensions'] as List<dynamic>)
            .map<RtpHeaderExtension>(
              (headExt) => RtpHeaderExtension.fromMap(headExt),
            )
            .toList(),
        fecMechanisms = data['fecMechanisms'] ?? [];

  static RtpCapabilities copy(
    RtpCapabilities old, {
    List<RtpCodecCapability>? codecs,
    List<RtpHeaderExtension>? headerExtensions,
    List<String>? fecMechanisms,
  }) {
    return RtpCapabilities(
      codecs:
          codecs ?? List<RtpCodecCapability>.from(old.codecs),
      headerExtensions: headerExtensions ?? List<RtpHeaderExtension>.from(old.headerExtensions),
      fecMechanisms: fecMechanisms ?? List<String>.from(old.fecMechanisms),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codecs':
          codecs.map((codec) => codec.toMap()).toList(),
    };
  }
}

///Direction of RTP header extension.
enum RtpHeaderDirection {
  sendRecv,
  sendOnly,
  recvOnly,
  inactive,
}

extension RtpHeaderDirectionExtension on RtpHeaderDirection {
  static const Map<String, RtpHeaderDirection> types = {
    'sendrecv': RtpHeaderDirection.sendRecv,
    'sendonly': RtpHeaderDirection.sendOnly,
    'recvonly': RtpHeaderDirection.recvOnly,
    'inactive': RtpHeaderDirection.inactive,
  };

  static const Map<RtpHeaderDirection, String> values = {
    RtpHeaderDirection.sendRecv: 'sendrecv',
    RtpHeaderDirection.sendOnly: 'sendonly',
    RtpHeaderDirection.recvOnly: 'recvonly',
    RtpHeaderDirection.inactive: 'inactive',
  };

  static RtpHeaderDirection fromString(String type) => types[type]!;

  String get value => values[this]!;
}

extension RTCRtpMediaTypeExtension on RTCRtpMediaType {
  static const Map<String, RTCRtpMediaType> types = {
    'audio': RTCRtpMediaType.RTCRtpMediaTypeAudio,
    'video': RTCRtpMediaType.RTCRtpMediaTypeVideo,
    'data': RTCRtpMediaType.RTCRtpMediaTypeData,
  };

  static const Map<RTCRtpMediaType, String> values = {
    RTCRtpMediaType.RTCRtpMediaTypeAudio: 'audio',
    RTCRtpMediaType.RTCRtpMediaTypeVideo: 'video',
    RTCRtpMediaType.RTCRtpMediaTypeData: 'data',
  };

  static RTCRtpMediaType fromString(String type) => types[type]!;

  static String value(RTCRtpMediaType type) => values[type]!;
}

/*
 * Provides information on RTCP feedback messages for a specific codec. Those
 * messages can be transport layer feedback messages or codec-specific feedback
 * messages. The list of RTCP feedbacks supported by mediasoup is defined in the
 * supportedRtpCapabilities.ts file.
 */
class RtcpFeedback {
  final String type;
  String parameter;

  RtcpFeedback({
    required this.type,
    this.parameter = '',
  });

  RtcpFeedback.fromMap(Map<String, dynamic> map)
      : type = map['type'],
        parameter = map['parameter'] ?? '';

  Map<String, String> toMap() {
    return {
      'type': type,
      'parameter': parameter,
    };
  }
}

class ExtendedRtpCodec {
  /*
 * Media kind.
 */
  final RTCRtpMediaType kind;

/*
 * The codec MIME media type/subtype (e.g. 'audio/opus', 'video/VP8').
 */
  final String mimeType;

/*
 * Codec clock rate expressed in Hertz.
 */
  final int clockRate;

/*
 * The number of channels supported (e.g. two for stereo). Just for audio.
 * Default 1.
 */
  final int? channels;

/*
 * Transport layer and codec-specific feedback messages for this codec.
 */
  final List<RtcpFeedback> rtcpFeedback;

  int? localPayloadType;
  int? localRtxPayloadType;
  int? remotePayloadType;
  int? remoteRtxPayloadType;
  Map<dynamic, dynamic> localParameters;
  Map<dynamic, dynamic> remoteParameters;

  ExtendedRtpCodec({
    required this.kind,
    required this.mimeType,
    required this.clockRate,
    this.channels = 1,
    this.rtcpFeedback = const [],
    this.localPayloadType,
    this.localRtxPayloadType,
    this.remotePayloadType,
    this.remoteRtxPayloadType,
    required this.localParameters,
    required this.remoteParameters,
  });
}

class RtpCodecCapability {
  /*
	 * Media kind.
	 */
  RTCRtpMediaType kind;

  /*
	 * The codec MIME media type/subtype (e.g. 'audio/opus', 'video/VP8').
	 */
  final String mimeType;

  /*
	 * The preferred RTP payload type.
	 */
  final int? preferredPayloadType;

  /*
	 * Codec clock rate expressed in Hertz.
	 */
  final int clockRate;

  /*
	 * The number of channels supported (e.g. two for stereo). Just for audio.
	 * Default 1.
	 */
  int? channels;

  /*
	 * Codec specific parameters. Some parameters (such as 'packetization-mode'
	 * and 'profile-level-id' in H264 or 'profile-id' in VP9) are critical for
	 * codec matching.
	 */
  Map<dynamic, dynamic> parameters;

  /*
	 * Transport layer and codec-specific feedback messages for this codec.
	 */
  final List<RtcpFeedback> rtcpFeedback;

  RtpCodecCapability({
    required this.kind,
    this.mimeType = '',
    this.preferredPayloadType,
    required this.clockRate,
    this.channels = 1,
    this.parameters = const {},
    this.rtcpFeedback = const [],
  });

  RtpCodecCapability.fromMap(Map<String, dynamic> data)
      : kind = RTCRtpMediaTypeExtension.fromString(data['kind']),
        mimeType = data['mimeType'],
        preferredPayloadType = data['preferredPayloadType'],
        clockRate = data['clockRate'],
        channels = data['channels'],
        parameters = data['parameters'],
        rtcpFeedback = data['rtcpFeedback']
            .map<RtcpFeedback>((rtcpFb) => RtcpFeedback.fromMap(rtcpFb))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'kind': RTCRtpMediaTypeExtension.value(kind),
      'mimeType': mimeType,
      'preferredPayloadType': preferredPayloadType,
      'clockRate': clockRate,
      'channels': channels,
      'parameters': parameters,
      'rtcpFeedback':
          rtcpFeedback.map((fb) => fb.toMap()).toList(),
    };
  }
}

class ExtendedRtpHeaderExtension {
  final RTCRtpMediaType kind;
  final String uri;
  final int sendId;
  final int recvId;
  final bool encrypt;
  RtpHeaderDirection direction;

  ExtendedRtpHeaderExtension({
    required this.kind,
    required this.uri,
    required this.sendId,
    required this.recvId,
    required this.encrypt,
    required this.direction,
  });
}

class RtpHeaderExtension {
  /*
	 * Media kind. If empty string, it's valid for all kinds.
	 * Default any media kind.
	 */
  final RTCRtpMediaType? kind;

  /*
  * The URI of the RTP header extension, as defined in RFC 5285.
  */
  final String? uri;

  /*
  * The preferred numeric identifier that goes in the RTP packet. Must be
  * unique.
  */
  final int? preferredId;

  /*
  * If true, it is preferred that the value in the header be encrypted as per
  * RFC 6904. Default false.
  */
  bool? preferredEncrypt;

  /*
	 * If 'sendrecv', mediasoup supports sending and receiving this RTP extension.
	 * 'sendonly' means that mediasoup can send (but not receive) it. 'recvonly'
	 * means that mediasoup can receive (but not send) it.
	 */
  RtpHeaderDirection? direction;

  RtpHeaderExtension({
    required this.kind,
    this.uri,
    this.preferredId,
    this.preferredEncrypt,
    this.direction,
  });

  RtpHeaderExtension.fromMap(Map data)
      : kind = RTCRtpMediaTypeExtension.fromString(data['kind']),
        uri = data['uri'],
        preferredId = data['preferredId'],
        preferredEncrypt = data['preferredEncrypt'],
        direction = RtpHeaderDirectionExtension.fromString(data['direction']);
}

class RtxSsrc {
  final int? ssrc;

  RtxSsrc(this.ssrc);

  RtxSsrc.fromMap(Map data) : ssrc = data['ssrc'];

  Map<String, dynamic> toMap() {
    return {
      'ssrc': ssrc,
    };
  }
}

/// Defines a RTP header extension within the RTP parameters. The list of RTP
/// header extensions supported by mediasoup is defined in the
/// supportedRtpCapabilities.ts file.
///
/// mediasoup does not currently support encrypted RTP header extensions and no
/// parameters are currently considered.
class RtpHeaderExtensionParameters {
  /// The URI of the RTP header extension, as defined in RFC 5285.
  final String? uri;

  /// The numeric identifier that goes in the RTP packet. Must be unique.
  final int? id;

  /// If true, the value in the header is encrypted as per RFC 6904. Default false.
  bool? encrypt;

  /// Configuration parameters for the header extension.
  final Map<dynamic, dynamic> parameters;

  RtpHeaderExtensionParameters({
    this.uri,
    this.id,
    this.encrypt,
    this.parameters = const {},
  });

  RtpHeaderExtensionParameters.fromMap(Map data)
      : uri = data['uri'],
        id = data['id'],
        encrypt = data['encrypt'],
        parameters = Map<dynamic, dynamic>.from(data['parameters']);

  Map<String, dynamic> toMap() {
    return {
      'uri': uri,
      'id': id,
      'encrypt': encrypt,
      'parameters': parameters,
    };
  }
}

class RtpEncodingParameters extends RTCRtpEncoding {
  /*
	 * Codec payload type this encoding affects. If unset, first media codec is
	 * chosen.
	 */
  final int? codecPayloadType;

  /*
	 * RTX stream information. It must contain a numeric ssrc field indicating
	 * the RTX SSRC.
	 */
  RtxSsrc? rtx;

  /*
	 * It indicates whether discontinuous RTP transmission will be used. Useful
	 * for audio (if the codec supports it) and for video screen sharing (when
	 * static content is being transmitted, this option disables the RTP
	 * inactivity checks in mediasoup). Default false.
	 */
  bool? dtx;

  /*
	 * Number of spatial and temporal layers in the RTP stream (e.g. 'L1T3').
	 * See webrtc-svc.
	 */
  @override
  // ignore: overridden_fields
  String? scalabilityMode;

  /*
   * Others.
   */
  bool? adaptivePtime;
  Priority? priority;
  Priority? networkPriority;

  RtpEncodingParameters({
    this.codecPayloadType,
    this.rtx,
    this.dtx,
    this.scalabilityMode,
    this.adaptivePtime,
    this.priority,
    this.networkPriority,
    super.active,
    super.maxBitrate,
    super.maxFramerate,
    super.minBitrate,
    super.numTemporalLayers = null,
    super.rid,
    super.scaleResolutionDownBy = null,
    super.ssrc,
  });

  static RtpEncodingParameters fromMap(Map data) {
    return RtpEncodingParameters(
      codecPayloadType: data['codecPayloadType'],
      rtx: data['rtx'] != null ? RtxSsrc.fromMap(data['rtx']) : null,
      dtx: data['dtx'],
      scalabilityMode: data['scalabilityMode'],
      adaptivePtime: data['adaptivePtime'],
      priority: data['priority'] != null
          ? PriorityExtension.fromString(data['priority'])
          : null,
      networkPriority: data['networkPriority'] != null
          ? PriorityExtension.fromString(data['networkPriority'])
          : null,
      active: data['active'] ?? true,
      maxBitrate: data['maxBitrate'],
      maxFramerate: data['maxFramerate'],
      minBitrate: data['minBitrate'],
      numTemporalLayers: data['numTemporalLayers'],
      rid: data['rid'],
      scaleResolutionDownBy: data['scaleResolutionDownBy'],
      ssrc: data['ssrc'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (rid != null) 'rid': rid,
      'active': active,
      if (maxBitrate != null) 'maxBitrate': maxBitrate,
      if (maxFramerate != null) 'maxFramerate': maxFramerate,
      if (minBitrate != null) 'minBitrate': minBitrate,
      if (numTemporalLayers != null) 'numTemporalLayers': numTemporalLayers,
      if (scaleResolutionDownBy != null)
        'scaleResolutionDownBy': scaleResolutionDownBy,
      if (ssrc != null) 'ssrc': ssrc,
      if (codecPayloadType != null) 'codecPayloadType': codecPayloadType,
      if (rtx != null) 'rtx': rtx?.toMap(),
      if (dtx != null) 'dtx': dtx,
      if (scalabilityMode != null) 'scalabilityMode': scalabilityMode,
      if (adaptivePtime != null) 'adaptivePtime': adaptivePtime,
      if (priority != null) 'priority': priority,
      if (networkPriority != null) 'networkPriority': networkPriority,
    };
  }

  static RtpEncodingParameters assign(
    RtpEncodingParameters prev,
    RtpEncodingParameters next,
  ) {
    return RtpEncodingParameters(
      codecPayloadType: next.codecPayloadType ?? prev.codecPayloadType,
      rtx: next.rtx ?? prev.rtx,
      dtx: next.dtx ?? prev.dtx,
      scalabilityMode: next.scalabilityMode ?? prev.scalabilityMode,
      adaptivePtime: next.adaptivePtime ?? prev.adaptivePtime,
      priority: next.priority ?? prev.priority,
      networkPriority: next.networkPriority ?? prev.networkPriority,
      active: next.active,
      maxBitrate: next.maxBitrate ?? prev.maxBitrate,
      maxFramerate: next.maxFramerate ?? prev.maxFramerate,
      minBitrate: next.minBitrate ?? prev.minBitrate,
      numTemporalLayers: next.numTemporalLayers ?? prev.numTemporalLayers,
      rid: next.rid ?? prev.rid,
      scaleResolutionDownBy:
          next.scaleResolutionDownBy ?? prev.scaleResolutionDownBy,
      ssrc: next.ssrc ?? prev.ssrc,
    );
  }
}

class CodecParameters {
  int? spropStereo; // sprop-stereo;
  final int? useinbandfec;
  final int? usedtx;
  final int? maxplaybackrate;
  final int? maxaveragebitrate;
  final int? ptime;
  final int? xGoogleStartBitrate; // x-google-start-bitrate;
  final int? xGoogleMaxBitrate; // x-google-max-bitrate;
  final int? xGoogleMinBitrate; // x-google-min-bitrate;

  int? get stereo {
    return spropStereo;
  }

  set stereo(int? value) => spropStereo = value;

  CodecParameters({
    this.spropStereo,
    this.useinbandfec,
    this.usedtx,
    this.maxplaybackrate,
    this.maxaveragebitrate,
    this.ptime,
    this.xGoogleStartBitrate,
    this.xGoogleMaxBitrate,
    this.xGoogleMinBitrate,
  });

  static CodecParameters copy(CodecParameters old) {
    return CodecParameters(
      spropStereo: old.spropStereo,
      useinbandfec: old.useinbandfec,
      usedtx: old.usedtx,
      maxplaybackrate: old.maxplaybackrate,
      maxaveragebitrate: old.maxaveragebitrate,
      ptime: old.ptime,
      xGoogleStartBitrate: old.xGoogleStartBitrate,
      xGoogleMaxBitrate: old.xGoogleMaxBitrate,
      xGoogleMinBitrate: old.xGoogleMinBitrate,
    );
  }

  List<String> get keys {
    final List<String> keys = <String>[];

    if (spropStereo != null) {
      keys.add('sprop-stereo');
    }
    if (stereo != null) {
      keys.add('stereo');
    }
    if (useinbandfec != null) {
      keys.add('useinbandfec');
    }
    if (usedtx != null) {
      keys.add('usedtx');
    }
    if (maxplaybackrate != null) {
      keys.add('maxplaybackrate');
    }
    if (maxaveragebitrate != null) {
      keys.add('maxaveragebitrate');
    }
    if (ptime != null) {
      keys.add('ptime');
    }
    if (xGoogleStartBitrate != null) {
      keys.add('x-google-start-bitrate');
    }
    if (xGoogleMaxBitrate != null) {
      keys.add('x-google-max-bitrate');
    }
    if (xGoogleMinBitrate != null) {
      keys.add('x-google-min-bitrate');
    }

    return keys;
  }

  operator [](String key) => toMap()[key];

  Map<String, int> toMap([bool stereoInMap = false]) {
    return {
      if (spropStereo != null)
        stereoInMap ? 'stereo' : 'sprop-stereo': spropStereo!,
      if (useinbandfec != null) 'useinbandfec': useinbandfec!,
      if (usedtx != null) 'usedtx': usedtx!,
      if (maxplaybackrate != null) 'maxplaybackrate': maxplaybackrate!,
      if (maxaveragebitrate != null) 'maxaveragebitrate': maxaveragebitrate!,
      if (ptime != null) 'ptime': ptime!,
      if (xGoogleStartBitrate != null)
        'x-google-start-bitrate': xGoogleStartBitrate!,
      if (xGoogleMaxBitrate != null) 'x-google-max-bitrate': xGoogleMaxBitrate!,
      if (xGoogleMinBitrate != null) 'x-google-min-bitrate': xGoogleMinBitrate!,
    };
  }
}

/// Provides information on codec settings within the RTP parameters. The list
/// of media codecs supported by mediasoup and their settings is defined in the
/// supportedRtpCapabilities.ts file.
class RtpCodecParameters {
  /// The codec MIME media type/subtype (e.g. 'audio/opus', 'video/VP8').
  final String mimeType;

  /// The value that goes in the RTP Payload Type Field. Must be unique.
  int payloadType;

  /// Codec clock rate expressed in Hertz.
  final int clockRate;

  /// The number of channels supported (e.g. two for stereo). Just for audio.
  /// Default 1.
  int? channels;

  /// Codec-specific parameters available for signaling. Some parameters (such
  /// as 'packetization-mode' and 'profile-level-id' in H264 or 'profile-id' in
  /// VP9) are critical for codec matching.
  // CodecParameters parameters;
  final Map<dynamic, dynamic> parameters;

  /// Transport layer and codec-specific feedback messages for this codec.
  List<RtcpFeedback> rtcpFeedback;

  RtpCodecParameters({
    required this.mimeType,
    required this.payloadType,
    required this.clockRate,
    this.channels = 1,
    this.parameters = const {},
    this.rtcpFeedback = const [],
  });

  RtpCodecParameters.fromMap(Map data)
      : mimeType = data['mimeType'],
        payloadType = data['payloadType'],
        clockRate = data['clockRate'],
        channels = data['channels'],
        parameters = Map<dynamic, dynamic>.from(data['parameters']),
        rtcpFeedback = data['rtcpFeedback'] != null
            ? data['rtcpFeedback']
                .map<RtcpFeedback>((e) => RtcpFeedback.fromMap(e))
                .toList()
            : [];

  Map<String, dynamic> toMap() {
    return {
      'mimeType': mimeType,
      'payloadType': payloadType,
      'clockRate': clockRate,
      'channels': channels,
      'parameters': parameters,
      'rtcpFeedback':
          rtcpFeedback.map((rtcpFB) => rtcpFB.toMap()).toList(),
    };
  }
}

/// The RTP send parameters describe a media stream received by mediasoup from
/// an endpoint through its corresponding mediasoup Producer. These parameters
/// may include a mid value that the mediasoup transport will use to match
/// received RTP packets based on their MID RTP extension value.
///
/// mediasoup allows RTP send parameters with a single encoding and with multiple
/// encodings (simulcast). In the latter case, each entry in the encodings array
/// must include a ssrc field or a rid field (the RID RTP extension value). Check
/// the Simulcast and SVC sections for more information.
///
/// The RTP receive parameters describe a media stream as sent by mediasoup to
/// an endpoint through its corresponding mediasoup Consumer. The mid value is
/// unset (mediasoup does not include the MID RTP extension into RTP packets
/// being sent to endpoints).
///
/// There is a single entry in the encodings array (even if the corresponding
/// producer uses simulcast). The consumer sends a single and continuous RTP
/// stream to the endpoint and spatial/temporal layer selection is possible via
/// consumer.setPreferredLayers().
///
/// As an exception, previous bullet is not true when consuming a stream over a
/// PipeTransport, in which all RTP streams from the associated producer are
/// forwarded verbatim through the consumer.
///
/// The RTP receive parameters will always have their ssrc values randomly
/// generated for all of its  encodings (and optional rtx: { ssrc: XXXX } if the
/// endpoint supports RTX), regardless of the original RTP send parameters in
/// the associated producer. This applies even if the producer's encodings have
/// rid set.
class RtpParameters {
  /// The MID RTP extension value as defined in the BUNDLE specification.
  String? mid;

  /// Media and RTX codecs in use.
  List<RtpCodecParameters> codecs;

  /// RTP header extensions in use.
  List<RtpHeaderExtensionParameters> headerExtensions;

  /// Transmitted RTP streams and their settings.
  List<RtpEncodingParameters> encodings;

  /// Parameters used for RTCP.
  RtcpParameters? rtcp;

  RtpParameters({
    this.mid,
    this.codecs = const [],
    this.headerExtensions = const [],
    this.encodings = const [],
    this.rtcp,
  });

  RtpParameters.fromMap(Map data)
      : mid = data['mid'],
        codecs = List<RtpCodecParameters>.from(
          data['codecs']
              .map((codec) => RtpCodecParameters.fromMap(codec))
              .toList(),
        ),
        headerExtensions = List<RtpHeaderExtensionParameters>.from(
          data['headerExtensions']
              .map(
                (headerExtension) =>
                    RtpHeaderExtensionParameters.fromMap(headerExtension),
              )
              .toList(),
        ),
        encodings = List<RtpEncodingParameters>.from(
          data['encodings']
              .map((encoding) => RtpEncodingParameters.fromMap(encoding))
              .toList(),
        ),
        rtcp = RtcpParameters.fromMap(data['rtcp']);

  static RtpParameters copy(
    RtpParameters old, {
    String? mid,
    List<RtpCodecParameters>? codecs,
    List<RtpHeaderExtensionParameters>? headerExtensions,
    List<RtpEncodingParameters>? encodings,
    RtcpParameters? rtcp,
  }) {
    return RtpParameters(
      codecs:
          codecs ?? List<RtpCodecParameters>.from(old.codecs),
      encodings: encodings ?? List<RtpEncodingParameters>.from(old.encodings),
      headerExtensions: headerExtensions ?? List<RtpHeaderExtensionParameters>.from(old.headerExtensions),
      mid: mid ?? old.mid,
      rtcp: rtcp ?? (old.rtcp != null
              ? RtcpParameters.copy(old.rtcp!)
              : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mid': mid,
      'codecs':
          codecs.map((codec) => codec.toMap()).toList(),
      'headerExtensions': headerExtensions
          .map(
            (rtpHeaderExtensionParameters) =>
                rtpHeaderExtensionParameters.toMap(),
          )
          .toList(),
      'encodings': encodings
          .map((encoding) => encoding.toMap())
          .toList(),
      'rtcp': rtcp?.toMap(),
    };
  }
}

/// Provides information on RTCP settings within the RTP parameters.
///
/// If no cname is given in a producer's RTP parameters, the mediasoup transport
/// will choose a random one that will be used into RTCP SDES messages sent to
/// all its associated consumers.
///
/// mediasoup assumes reducedSize to always be true.
class RtcpParameters extends RTCRTCPParameters {
  /*
	 * Whether RTCP-mux is used. Default true.
	 */
  bool? mux;

  RtcpParameters({
    this.mux,
    String cname = '',
    bool reducedSize = true,
  }) : super(cname, reducedSize);

  factory RtcpParameters.fromMap(Map<dynamic, dynamic> map) {
    return RtcpParameters(
      cname: map['cname'],
      mux: map['mux'],
      reducedSize: map['reducedSize'],
    );
  }

  static RtcpParameters copy(
    RtcpParameters old, {
    bool? mux,
    String? cname,
    bool? reducedSize,
  }) {
    return RtcpParameters(
      mux: mux ?? old.mux,
      cname: cname ?? old.cname,
      reducedSize: reducedSize ?? old.reducedSize,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'cname': cname,
      'reducedSize': reducedSize,
      'mux': mux,
    };
  }
}
