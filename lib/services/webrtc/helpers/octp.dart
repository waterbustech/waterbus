// ignore: unused_import
// ignore_for_file: non_constant_identifier_names, unnecessary_statements, unnecessary_null_comparison, depend_on_referenced_packages

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:h264_profile_level_id/h264_profile_level_id.dart';

// Project imports:
import 'package:waterbus/services/webrtc/helpers/rtp_paramenters.dart';

String RTP_PROBATOR_MID = 'probator';
int RTP_PROBATOR_SSRC = 1234;
int RTP_PROBATOR_CODEC_PAYLOAD_TYPE = 127;

class Ortc {
  /// Validates RtcpFeedback. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtcpFeedback(RtcpFeedback? fb) {
    if (fb == null) {
      throw 'fb is not an object';
    }

    // type is mandatory.
    if (fb.type.isEmpty) {
      throw 'missing fb.type';
    }

    // parameter is optional. If unset set it to an empty string.
    if (fb.parameter.isEmpty == true) {
      fb.parameter = '';
    }
  }

  /// Validates RtpCodecCapability. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpCodecCapability(RtpCodecCapability? codec) {
    final RegExp mimeTypeRegex = RegExp("^(audio|video)/(.+)");

    if (codec == null) {
      throw 'codec is not an object';
    }

    // maimeType is mandatory.
    if (codec.mimeType.isEmpty) {
      throw 'missing codec.mimeType';
    }

    final Iterable<RegExpMatch> mimeTypeMatch =
        mimeTypeRegex.allMatches(codec.mimeType);

    if (mimeTypeMatch.isEmpty) {
      throw 'invalid codec.mimeType';
    }

    // Just override kind with media component of mimeType.
    codec.kind = RTCRtpMediaTypeExtension.fromString(
      mimeTypeMatch.elementAt(0).group(1)!.toLowerCase(),
    );

    // // preferredPayloadType is optional.
    // if (codec.preferredPayloadType == null) {
    //   throw ('invalid codec.preferredPayloadType');
    // }

    // clockRate is mandatory.
    // if (codec.clockRate == null) {
    //   throw ('missing codec.clockRate');
    // }

    // channels is optional. If unset, set it to 1 (just if audio).
    if (codec.kind == RTCRtpMediaType.RTCRtpMediaTypeAudio) {
      codec.channels ??= 1;
    } else {
      codec.channels = null;
    }

    // // parameters is optional. if unset, set it to an empty object.
    // if (codec.parameters == null) {
    //   codec.parameters = {};
    // }

    for (final key in codec.parameters.keys) {
      var value = codec.parameters[key];

      if (value == null) {
        codec.parameters[key] = '';
        value = '';
      }

      if (value is! String && value is! int) {
        throw 'invalid codec parameter [key:${key}s, value:$value';
      }

      // Specific parameters validation.
      if (key == 'apt') {
        if (value is! int) {
          throw 'invalid codec apt paramter';
        }
      }

      // // rtcpFeedback is optional. If unset, set it to an empty array.
      // // || codec.rtcpFeedback is! List<RtcpFeedback>
      // if (codec.rtcpFeedback == null) {
      //   codec.rtcpFeedback = <RtcpFeedback>[];
      // }

      for (final RtcpFeedback fb in codec.rtcpFeedback) {
        validateRtcpFeedback(fb);
      }
    }
  }

  /// Validates RtpHeaderExtension. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpHeaderExtension(RtpHeaderExtension? ext) {
    if (ext == null) {
      throw 'ext is not an object';
    }

    // // kind is optional. If unset set it to an empty string.
    // if (ext.kind == null || ext.kind is! RTCRtpMediaType) {
    //   ext.kind = ''
    // }

    if (ext.kind != RTCRtpMediaType.RTCRtpMediaTypeAudio &&
        ext.kind != RTCRtpMediaType.RTCRtpMediaTypeVideo) {
      throw 'invalid ext.kind';
    }

    // uri is mandatory.
    if (ext.uri == null) {
      throw 'missing ext.uri';
    }

    // preferredId is mandatory.
    if (ext.preferredId == null) {
      throw 'missing ext.preferredId';
    }

    // preferredEncrypt is optional. If unset set it to false.
    ext.preferredEncrypt ??= false;

    // direction is optional. If unset set it to sendrecv.
    ext.direction ??= RtpHeaderDirection.sendRecv;
  }

  /// Validates RtpCapabilities. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpCapabilities(RtpCapabilities? caps) {
    if (caps == null) {
      throw 'caps is not an object...';
    }

    // // codecs is optional. If unset, fill with an empty array.
    // // if (caps.codecs != null && caps.codecs is! List<RtpCodecCapability>) {
    // //   throw ('caps.codecs is not an array');
    // // } else
    // if (caps.codecs == null) {
    //   caps.codecs = <RtpCodecCapability>[];
    // }

    for (final RtpCodecCapability codec in caps.codecs) {
      validateRtpCodecCapability(codec);
    }

    // // headerExtensions is optional. If unset, fill with an empty array.
    // // if (caps.headerExtensions == null &&
    // //     caps.headerExtensions is! List<RtpHeaderExtension>) {
    // //   throw ('caps.headerExtensions is not an array');
    // // } else
    // if (caps.headerExtensions == null) {
    //   caps.headerExtensions = <RtpHeaderExtension>[];
    // }

    for (final RtpHeaderExtension ext in caps.headerExtensions) {
      validateRtpHeaderExtension(ext);
    }
  }

  /// Validates RtpHeaderExtensionParameteters. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpHeaderExtensionParameters(
    RtpHeaderExtensionParameters? ext,
  ) {
    if (ext == null) {
      throw 'ext is not an object';
    }

    // uri is mandatory.
    if (ext.uri == null) {
      throw 'missing ext.uri';
    }

    // id is mandatory.
    if (ext.id == null) {
      throw 'missing ext.id';
    }

    // encrypt is optional. If unset set it to false.
    ext.encrypt ??= false;

    // // parameters is optional. If unset, set it to an empty object.
    // if (ext.parameters == null) {
    //   ext.parameters = <dynamic, dynamic>{};
    // }

    for (final String key in ext.parameters.keys) {
      var value = ext.parameters[key];

      if (value == null) {
        ext.parameters[key] = '';
        value = '';
      }

      if (value is! String && value is! int) {
        throw 'invalid header extension parameter';
      }
    }
  }

  /// Validates RtpEncodingParameters. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpEncodingParameters(RtpEncodingParameters encoding) {
    if (encoding == null) {
      throw 'encoding is not an object';
    }

    // ssrc is optional.
    if (encoding.rtx != null) {
      if (encoding.rtx?.ssrc == null) {
        throw 'missing encoding.rtx.ssrc';
      }
    }

    // dtx is optional. If unset set it to false.
    encoding.dtx ??= false;
  }

  /// Validates RtcpParameters. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtcpParameters(RtcpParameters? rtcp) {
    if (rtcp == null) {
      throw 'rtcp is not an object';
    }

    // reducedSize is optional. If unset set it to true.
    rtcp.reducedSize;
  }

  /// Validates RtpCodecParameters. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpCodecParameters(RtpCodecParameters? codec) {
    final RegExp mimeTypeRegex = RegExp("^(audio|video)/(.+)");

    if (codec == null) {
      throw 'codec is not an object';
    }

    // // mimeType is mandatory.
    // if (codec.mimeType == null) {
    //   throw ('missing codec.mimeType');
    // }

    final Iterable<RegExpMatch> mimeTypeMatch =
        mimeTypeRegex.allMatches(codec.mimeType);

    if (mimeTypeMatch == null) {
      throw 'invalid codec.mimeType';
    }

    // payloadType is mandatory.
    // if (codec.payloadType == null) {
    //   throw ('missing codec.payloadType');
    // }
    //
    // // clockRate is mandatory.
    // if (codec.clockRate == null) {
    //   throw ('missing codec.clockRate');
    // }

    final RTCRtpMediaType kind = RTCRtpMediaTypeExtension.fromString(
      mimeTypeMatch.elementAt(0).group(1)!.toLowerCase(),
    );

    // channels is optional. If unset, set it to 1 (just if audio).
    if (kind == RTCRtpMediaType.RTCRtpMediaTypeAudio) {
      codec.channels ??= 1;
    } else {
      codec.channels = null;
    }

    // // Parameters is optional. if Unset, set it to an empty object.
    // if (codec.parameters == null) {
    //   codec.parameters = <dynamic, dynamic>{};
    // }

    for (final String key in codec.parameters.keys) {
      var value = codec.parameters[key];
      if (value == null) {
        codec.parameters[key] = '';
        value = '';
      }

      if (value is! String && value is! int) {
        throw 'invalid codec parameter [key:${key}s, value:$value]';
      }

      // Specific parameters validation.
      if (key == 'apt') {
        if (value is! int) {
          throw 'invalid codec apt parameter';
        }
      }
    }

    // // rtcpFeedback is optional. If unset, set it to an empty array.
    // if (codec.rtcpFeedback == null ||
    //     codec.rtcpFeedback is! List<RtcpFeedback>) {
    //   codec.rtcpFeedback = <RtcpFeedback>[];
    // }

    for (final RtcpFeedback fb in codec.rtcpFeedback) {
      validateRtcpFeedback(fb);
    }
  }

  /// Validates RtpParameters. It may modify given data by adding missing
  /// fields with default values.
  /// It throws if invalid.
  static void validateRtpParameters(RtpParameters params) {
    // // codecs is mandatory.
    // if (params.codecs == null) {
    //   throw ('missing params.codecs');
    // }

    for (final RtpCodecParameters codec in params.codecs) {
      validateRtpCodecParameters(codec);
    }

    // // headerExtensions is optional. If unset, fill with an empty array.
    // if (params.headerExtensions == null) {
    //   params.headerExtensions = <RtpHeaderExtensionParameters>[];
    // }

    for (final RtpHeaderExtensionParameters ext in params.headerExtensions) {
      validateRtpHeaderExtensionParameters(ext);
    }

    // // encodings is optional. If unset, fill with an empty array.
    // if (params.encodings == null) {
    //   params.encodings = <RtpEncodingParameters>[];
    // }

    for (final RtpEncodingParameters encoding in params.encodings) {
      validateRtpEncodingParameters(encoding);
    }

    // rtcp is optional. If unset, fill with an empty object.
    params.rtcp ??= RtcpParameters(mux: false);

    validateRtcpParameters(params.rtcp);
  }

  static bool isRtxCodec(codec) {
    if (codec == null) {
      return false;
    }

    return RegExp(r'.+\/rtx$').hasMatch(codec.mimeType);
  }

  static bool matchCodecs({
    aCodec,
    bCodec,
    bool strict = false,
    modify = false,
  }) {
    final String aMimeType = aCodec.mimeType.toLowerCase();
    final String bMimeType = bCodec.mimeType.toLowerCase();

    if (aMimeType != bMimeType) {
      return false;
    }

    if (aCodec.clockRate != bCodec.clockRate) {
      return false;
    }

    if (aCodec.channels != bCodec.channels) {
      return false;
    }

    // Per codec special checks.
    switch (aMimeType) {
      case 'video/h264':
        {
          final aPacketizationMode =
              aCodec.parameters['packetization-mode'] ?? 0;
          final bPacketizationMode =
              bCodec.parameters['packetization-mode'] ?? 0;

          if (aPacketizationMode != bPacketizationMode) {
            return false;
          }

          // If strict matching check profile-level-id.
          if (strict) {
            if (!H264Utils.isSameProfile(
              aCodec.parameters,
              bCodec.parameters,
            )) {
              return false;
            }

            String? selectedProfileLevelId;

            try {
              selectedProfileLevelId =
                  H264Utils.generateProfileLevelIdForAnswer(
                local_supported_params: aCodec.parameters,
                remote_offered_params: bCodec.parameters,
              );
            } catch (error) {
              return false;
            }

            if (modify) {
              if (selectedProfileLevelId != null) {
                aCodec.parameters['profile-level-id'] = selectedProfileLevelId;
                bCodec.parameters['profile-level-id'] = selectedProfileLevelId;
              } else {
                aCodec.parameters.remove('profile-level-id');
                bCodec.parameters.remove('profile-level-id');
              }
            }
          }
          break;
        }

      case 'video/vp9':
        {
          // If strict matching heck profile-id.
          if (strict) {
            final aProfileId = aCodec.parameters['profile-id'] ?? 0;
            final bProfileId = aCodec.parameters['profile-id'] ?? 0;

            if (aProfileId != bProfileId) {
              return false;
            }
          }
          break;
        }
    }

    return true;
  }

  static List<RtcpFeedback> reduceRtcpFeedback(
    RtpCodecCapability codecA,
    RtpCodecCapability codecB,
  ) {
    final List<RtcpFeedback> reducedRtcpFeedback = <RtcpFeedback>[];

    for (final RtcpFeedback aFb in codecA.rtcpFeedback) {
      final RtcpFeedback? matchingBFb = codecB.rtcpFeedback.firstWhereOrNull(
        (bFb) =>
            bFb.type == aFb.type &&
            (bFb.parameter == aFb.parameter ||
                (bFb.parameter == '' && aFb.parameter == '')),
      );

      if (matchingBFb != null) {
        reducedRtcpFeedback.add(matchingBFb);
      }
    }

    return reducedRtcpFeedback;
  }

  static bool matchHeaderExtensions(
    RtpHeaderExtension aExt,
    RtpHeaderExtension bExt,
  ) {
    if (aExt.kind != null && bExt.kind != null && aExt.kind != bExt.kind) {
      return false;
    }

    if (aExt.uri != bExt.uri) {
      return false;
    }

    return true;
  }

  /// Generate extended RTP capabilities for sending and receiving.
  static ExtendedRtpCapabilities getExtendedRtpCapabilities(
    RtpCapabilities localCaps,
    RtpCapabilities remoteCaps,
  ) {
    final ExtendedRtpCapabilities extendedRtpCapabilities =
        ExtendedRtpCapabilities(
      codecs: [],
      headerExtensions: [],
    );

    // Match media codecs and keep the order preferred by remoteCaps.
    for (final RtpCodecCapability remoteCodec in remoteCaps.codecs) {
      if (isRtxCodec(remoteCodec)) {
        continue;
      }

      final RtpCodecCapability? matchingLocalCodec =
          localCaps.codecs.firstWhereOrNull(
        (localCodec) => matchCodecs(
          aCodec: localCodec,
          bCodec: remoteCodec,
          strict: true,
          modify: true,
        ),
      );

      if (matchingLocalCodec == null) {
        continue;
      }

      final ExtendedRtpCodec extendedCodec = ExtendedRtpCodec(
        mimeType: matchingLocalCodec.mimeType,
        kind: matchingLocalCodec.kind,
        clockRate: matchingLocalCodec.clockRate,
        channels: matchingLocalCodec.channels,
        localPayloadType: matchingLocalCodec.preferredPayloadType,
        remotePayloadType: remoteCodec.preferredPayloadType,
        localParameters: matchingLocalCodec.parameters,
        remoteParameters: remoteCodec.parameters,
        rtcpFeedback: reduceRtcpFeedback(matchingLocalCodec, remoteCodec),
      );

      extendedRtpCapabilities.codecs.add(extendedCodec);
    }

    // Match RTX codecs.
    for (final ExtendedRtpCodec extendedCodec
        in extendedRtpCapabilities.codecs) {
      final RtpCodecCapability? matchingLocalRtxCodec =
          localCaps.codecs.firstWhereOrNull(
        (localCodec) =>
            isRtxCodec(localCodec) &&
            localCodec.parameters['apt'] == extendedCodec.localPayloadType,
      );

      final RtpCodecCapability? matchingRemoteRtxCodec =
          remoteCaps.codecs.firstWhereOrNull(
        (remoteCodec) =>
            isRtxCodec(remoteCodec) &&
            remoteCodec.parameters['apt'] == extendedCodec.remotePayloadType,
      );

      if (matchingLocalRtxCodec != null && matchingRemoteRtxCodec != null) {
        extendedCodec.localRtxPayloadType =
            matchingLocalRtxCodec.preferredPayloadType;
        extendedCodec.remoteRtxPayloadType =
            matchingRemoteRtxCodec.preferredPayloadType;
      }
    }

    // Match header extensions.
    for (final RtpHeaderExtension remoteExt in remoteCaps.headerExtensions) {
      final RtpHeaderExtension? matchingLocalExt =
          localCaps.headerExtensions.firstWhereOrNull(
        (localExt) => matchHeaderExtensions(localExt, remoteExt),
      );

      if (matchingLocalExt == null) {
        continue;
      }

      final ExtendedRtpHeaderExtension extendedExt = ExtendedRtpHeaderExtension(
        kind: remoteExt.kind!,
        uri: remoteExt.uri!,
        sendId: matchingLocalExt.preferredId!,
        recvId: remoteExt.preferredId!,
        encrypt: matchingLocalExt.preferredEncrypt!,
        direction: RtpHeaderDirection.sendRecv,
      );

      switch (remoteExt.direction) {
        case RtpHeaderDirection.sendRecv:
          extendedExt.direction = RtpHeaderDirection.sendRecv;
          break;
        case RtpHeaderDirection.recvOnly:
          extendedExt.direction = RtpHeaderDirection.sendOnly;
          break;
        case RtpHeaderDirection.sendOnly:
          extendedExt.direction = RtpHeaderDirection.recvOnly;
          break;
        case RtpHeaderDirection.inactive:
          extendedExt.direction = RtpHeaderDirection.inactive;
          break;
        default:
          break;
      }

      extendedRtpCapabilities.headerExtensions.add(extendedExt);
    }

    return extendedRtpCapabilities;
  }

  /// Create RTP parameters for a Consumer for the RTP probator.
  static RtpParameters generateProbatorRtpparameters(
    RtpParameters videoRtpParameters,
  ) {
    // Clone given reference video RTP parameters.
    videoRtpParameters = RtpParameters.copy(videoRtpParameters);

    // This may throw.
    validateRtpParameters(videoRtpParameters);

    final RtpParameters rtpParameters = RtpParameters(
      mid: RTP_PROBATOR_MID,
      codecs: [],
      headerExtensions: [],
      encodings: [RtpEncodingParameters(ssrc: RTP_PROBATOR_SSRC)],
      rtcp: RtcpParameters(cname: 'probator'),
    );

    rtpParameters.codecs.add(videoRtpParameters.codecs.first);
    rtpParameters.codecs.first.payloadType = RTP_PROBATOR_CODEC_PAYLOAD_TYPE;
    rtpParameters.headerExtensions = videoRtpParameters.headerExtensions;

    return rtpParameters;
  }

  /// Reduce given codecs by returning an array of codecs "compatible" with the
  /// given capability codec. If no capability codec is given, take the first
  /// one(s).
  ///
  /// Given codecs must be generated by ortc.getSendingRtpParameters() or
  /// ortc.getSendingRemoteRtpParameters().
  ///
  /// The returned array of codecs also include a RTX codec if available.
  static List<RtpCodecParameters> reduceCodecs(
    List<RtpCodecParameters> codecs,
    RtpCodecCapability? capCodec,
  ) {
    final List<RtpCodecParameters> filteredCodecs = [];

    // if no capability codec is given, take the first one (and RTX).
    if (capCodec == null) {
      filteredCodecs.add(codecs.first);

      if (codecs.length > 1 && isRtxCodec(codecs[1])) {
        filteredCodecs.add(codecs[1]);
      }
    } else {
      // Otherwise look for a compatible set of codecs.
      for (int idx = 0; idx < codecs.length; ++idx) {
        if (matchCodecs(aCodec: codecs[idx], bCodec: capCodec)) {
          filteredCodecs.add(codecs[idx]);

          if (isRtxCodec(codecs[idx + 1])) {
            filteredCodecs.add(codecs[idx + 1]);
          }

          break;
        }
      }

      if (filteredCodecs.isEmpty) {
        throw 'no matching codec found';
      }
    }

    return filteredCodecs;
  }

  /// Generate RTP parameters of the given kind suitable for the remote SDP answer.
  static RtpParameters getSendingRemoteRtpParameters(
    RTCRtpMediaType kind,
    ExtendedRtpCapabilities extendedRtpCapabilities,
  ) {
    final RtpParameters rtpParameters = RtpParameters(
      codecs: [],
      headerExtensions: [],
      encodings: [],
      rtcp: RtcpParameters(),
    );

    for (final ExtendedRtpCodec extendedCodec
        in extendedRtpCapabilities.codecs) {
      if (extendedCodec.kind != kind) {
        continue;
      }

      final RtpCodecParameters codec = RtpCodecParameters(
        mimeType: extendedCodec.mimeType,
        payloadType: extendedCodec.localPayloadType!,
        clockRate: extendedCodec.clockRate,
        channels: extendedCodec.channels,
        parameters: extendedCodec.remoteParameters,
        rtcpFeedback: extendedCodec.rtcpFeedback,
      );

      rtpParameters.codecs.add(codec);

      // Add RTX codec.
      if (extendedCodec.localRtxPayloadType != null) {
        final RtpCodecParameters rtxCodec = RtpCodecParameters(
          mimeType: '${RTCRtpMediaTypeExtension.value(kind)}/rtx',
          payloadType: extendedCodec.localRtxPayloadType!,
          clockRate: extendedCodec.clockRate,
          parameters: {
            'apt': extendedCodec.localPayloadType,
          },
          rtcpFeedback: [],
        );

        rtpParameters.codecs.add(rtxCodec);
      }
    }

    for (final ExtendedRtpHeaderExtension extendedExtension
        in extendedRtpCapabilities.headerExtensions) {
      // Ignore RTP extensions of a different kind and those not valid for sending.
      if ((extendedExtension.kind != kind) ||
          (extendedExtension.direction != RtpHeaderDirection.sendRecv &&
              extendedExtension.direction != RtpHeaderDirection.sendOnly)) {
        continue;
      }

      final RtpHeaderExtensionParameters ext = RtpHeaderExtensionParameters(
        uri: extendedExtension.uri,
        id: extendedExtension.sendId,
        encrypt: extendedExtension.encrypt,
        parameters: {},
      );

      rtpParameters.headerExtensions.add(ext);
    }

    // Reduce codecs' RTCP feedback. Use Transport-CC if available, REMB otherwise.
    if (rtpParameters.headerExtensions.any(
      (ext) =>
          ext.uri ==
          'http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01',
    )) {
      for (final RtpCodecParameters codec in rtpParameters.codecs) {
        codec.rtcpFeedback =
            codec.rtcpFeedback.where((fb) => fb.type != 'goog-remb').toList();
      }
    } else if (rtpParameters.headerExtensions.any(
      (ext) =>
          ext.uri ==
          'http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time',
    )) {
      for (final RtpCodecParameters codec in rtpParameters.codecs) {
        codec.rtcpFeedback = codec.rtcpFeedback
            .where((fb) => fb.type != 'transport-cc')
            .toList();
      }
    } else {
      for (final RtpCodecParameters codec in rtpParameters.codecs) {
        codec.rtcpFeedback = codec.rtcpFeedback
            .where(
              (fb) => fb.type != 'transport-cc' && fb.type != 'goog-remb',
            )
            .toList();
      }
    }

    return rtpParameters;
  }

  /// Generate RTP capabilities for receiving media based on the given extended
  /// RTP capabilities.
  static RtpCapabilities getRecvRtpCapabilities(
    ExtendedRtpCapabilities extendedRtpCapabilities,
  ) {
    final RtpCapabilities rtpCapabilities = RtpCapabilities(
      codecs: [],
      headerExtensions: [],
    );

    for (final ExtendedRtpCodec extendedCodec
        in extendedRtpCapabilities.codecs) {
      final RtpCodecCapability codec = RtpCodecCapability(
        mimeType: extendedCodec.mimeType,
        kind: extendedCodec.kind,
        preferredPayloadType: extendedCodec.remotePayloadType,
        clockRate: extendedCodec.clockRate,
        channels: extendedCodec.channels,
        parameters: extendedCodec.localParameters,
        rtcpFeedback: extendedCodec.rtcpFeedback,
      );

      rtpCapabilities.codecs.add(codec);

      // Add RTX codec.
      if (extendedCodec.remoteRtxPayloadType == null) {
        continue;
      }

      final RtpCodecCapability rtxCodec = RtpCodecCapability(
        mimeType: '${RTCRtpMediaTypeExtension.value(extendedCodec.kind)}/rtx',
        kind: extendedCodec.kind,
        preferredPayloadType: extendedCodec.remoteRtxPayloadType,
        clockRate: extendedCodec.clockRate,
        parameters: {
          'apt': extendedCodec.remotePayloadType,
        },
        rtcpFeedback: [],
      );

      rtpCapabilities.codecs.add(rtxCodec);
    }

    for (final ExtendedRtpHeaderExtension extendedExtension
        in extendedRtpCapabilities.headerExtensions) {
      // Ignore RTP extensions not valid for receiving.
      if (extendedExtension.direction != RtpHeaderDirection.sendRecv &&
          extendedExtension.direction != RtpHeaderDirection.recvOnly) {
        continue;
      }

      final RtpHeaderExtension ext = RtpHeaderExtension(
        kind: extendedExtension.kind,
        uri: extendedExtension.uri,
        preferredId: extendedExtension.recvId,
        preferredEncrypt: extendedExtension.encrypt,
        direction: extendedExtension.direction,
      );

      rtpCapabilities.headerExtensions.add(ext);
    }

    return rtpCapabilities;
  }

  /// Generate RTP parameters of the given kind for sending media.
  /// NOTE: mid, encodings and rtcp fields are left empty.
  static RtpParameters getSendingRtpParameters(
    RTCRtpMediaType kind,
    ExtendedRtpCapabilities extendedRtpCapabilities,
  ) {
    final RtpParameters rtpParameters = RtpParameters(
      codecs: [],
      headerExtensions: [],
      encodings: [],
      rtcp: RtcpParameters(),
    );

    for (final ExtendedRtpCodec extendedCodec
        in extendedRtpCapabilities.codecs) {
      if (extendedCodec.kind != kind) {
        continue;
      }

      final RtpCodecParameters codec = RtpCodecParameters(
        mimeType: extendedCodec.mimeType,
        payloadType: extendedCodec.localPayloadType!,
        clockRate: extendedCodec.clockRate,
        channels: extendedCodec.channels,
        parameters: extendedCodec.localParameters,
        rtcpFeedback: extendedCodec.rtcpFeedback,
      );

      rtpParameters.codecs.add(codec);

      // Add RTX codec.
      if (extendedCodec.localRtxPayloadType != null) {
        final RtpCodecParameters rtxCodec = RtpCodecParameters(
          mimeType: '${RTCRtpMediaTypeExtension.value(extendedCodec.kind)}/rtx',
          payloadType: extendedCodec.localRtxPayloadType!,
          clockRate: extendedCodec.clockRate,
          parameters: {
            'apt': extendedCodec.localPayloadType,
          },
          rtcpFeedback: [],
        );

        rtpParameters.codecs.add(rtxCodec);
      }
    }

    for (final ExtendedRtpHeaderExtension extendedExtension
        in extendedRtpCapabilities.headerExtensions) {
      // Ignore RTP extensions of a different kind and those not valid for sending.
      if ((extendedExtension.kind != kind) ||
          (extendedExtension.direction != RtpHeaderDirection.sendRecv &&
              extendedExtension.direction != RtpHeaderDirection.sendOnly)) {
        continue;
      }

      final RtpHeaderExtensionParameters ext = RtpHeaderExtensionParameters(
        uri: extendedExtension.uri,
        id: extendedExtension.sendId,
        encrypt: extendedExtension.encrypt,
        parameters: {},
      );

      rtpParameters.headerExtensions.add(ext);
    }

    return rtpParameters;
  }

  /// Whether media can be sent based on the given RTP capabilities.
  static bool canSend(
    RTCRtpMediaType kind,
    ExtendedRtpCapabilities extendedRtpCapabilities,
  ) {
    return extendedRtpCapabilities.codecs.any((codec) => codec.kind == kind);
  }

  /// Whether the given RTP parameters can be received with the given RTP
  /// capabilities.
  static bool canReceive(
    RtpParameters rtpParameters,
    ExtendedRtpCapabilities? extendedRtpCapabilities,
  ) {
    // This may throw.
    validateRtpParameters(rtpParameters);

    if (rtpParameters.codecs.isEmpty) {
      return false;
    }

    final RtpCodecParameters firstMediaCodec = rtpParameters.codecs.first;

    return extendedRtpCapabilities?.codecs.any(
          (codec) => codec.remotePayloadType == firstMediaCodec.payloadType,
        ) ??
        false;
  }
}

class ExtendedRtpCapabilities {
  final List<ExtendedRtpCodec> codecs;
  final List<ExtendedRtpHeaderExtension> headerExtensions;

  ExtendedRtpCapabilities({
    this.codecs = const [],
    this.headerExtensions = const [],
  });
}
