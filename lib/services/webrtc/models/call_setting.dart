// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:waterbus/services/webrtc/models/codec.dart';
import 'package:waterbus/services/webrtc/models/video_layout.dart';
import 'package:waterbus/services/webrtc/models/video_quality.dart';

class CallSetting {
  final bool isLowBandwidthMode;
  final bool isAudioMuted;
  final bool echoCancellationEnabled;
  final bool noiseSuppressionEnabled;
  final bool agcEnabled;
  final bool isVideoMuted;
  final WebRTCCodec preferedCodec;
  final VideoQuality videoQuality;
  final VideoLayout videoLayout;
  CallSetting({
    this.isLowBandwidthMode = false,
    this.isAudioMuted = false,
    this.echoCancellationEnabled = true,
    this.noiseSuppressionEnabled = true,
    this.agcEnabled = true,
    this.isVideoMuted = false,
    this.preferedCodec = WebRTCCodec.h264,
    this.videoQuality = VideoQuality.low,
    this.videoLayout = VideoLayout.gridView,
  });

  CallSetting copyWith({
    bool? isLowBandwidthMode,
    bool? isAudioMuted,
    bool? echoCancellationEnabled,
    bool? noiseSuppressionEnabled,
    bool? agcEnabled,
    bool? isVideoMuted,
    WebRTCCodec? preferedCodec,
    VideoQuality? videoQuality,
    VideoLayout? videoLayout,
  }) {
    return CallSetting(
      isLowBandwidthMode: isLowBandwidthMode ?? this.isLowBandwidthMode,
      isAudioMuted: isAudioMuted ?? this.isAudioMuted,
      echoCancellationEnabled:
          echoCancellationEnabled ?? this.echoCancellationEnabled,
      noiseSuppressionEnabled:
          noiseSuppressionEnabled ?? this.noiseSuppressionEnabled,
      agcEnabled: agcEnabled ?? this.agcEnabled,
      isVideoMuted: isVideoMuted ?? this.isVideoMuted,
      preferedCodec: preferedCodec ?? this.preferedCodec,
      videoQuality: videoQuality ?? this.videoQuality,
      videoLayout: videoLayout ?? this.videoLayout,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isLowBandwidthMode': isLowBandwidthMode,
      'isAudioMuted': isAudioMuted,
      'echoCancellationEnabled': echoCancellationEnabled,
      'noiseSuppressionEnabled': noiseSuppressionEnabled,
      'agcEnabled': agcEnabled,
      'isVideoMuted': isVideoMuted,
      'preferedCodec': preferedCodec.index,
      'videoQuality': videoQuality.index,
      'videoLayout': videoLayout.index,
    };
  }

  factory CallSetting.fromMap(Map<String, dynamic> map) {
    return CallSetting(
      isLowBandwidthMode: map['isLowBandwidthMode'] as bool,
      isAudioMuted: map['isAudioMuted'] as bool,
      echoCancellationEnabled: map['echoCancellationEnabled'] as bool,
      noiseSuppressionEnabled: map['noiseSuppressionEnabled'] as bool,
      agcEnabled: map['agcEnabled'] as bool,
      isVideoMuted: map['isVideoMuted'] as bool,
      preferedCodec: WebRTCCodec.values[map['preferedCodec']],
      videoQuality: VideoQuality.values[map['videoQuality']],
      videoLayout: VideoLayout.values[map['videoLayout']],
    );
  }

  String toJson() => json.encode(toMap());

  factory CallSetting.fromJson(String source) =>
      CallSetting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallSetting(isLowBandwidthMode: $isLowBandwidthMode, isAudioMuted: $isAudioMuted, echoCancellationEnabled: $echoCancellationEnabled, noiseSuppressionEnabled: $noiseSuppressionEnabled, agcEnabled: $agcEnabled, isVideoMuted: $isVideoMuted, preferedCodec: $preferedCodec, videoQuality: $videoQuality, videoLayout: $videoLayout)';
  }

  @override
  bool operator ==(covariant CallSetting other) {
    if (identical(this, other)) return true;

    return other.isLowBandwidthMode == isLowBandwidthMode &&
        other.isAudioMuted == isAudioMuted &&
        other.echoCancellationEnabled == echoCancellationEnabled &&
        other.noiseSuppressionEnabled == noiseSuppressionEnabled &&
        other.agcEnabled == agcEnabled &&
        other.isVideoMuted == isVideoMuted &&
        other.preferedCodec == preferedCodec &&
        other.videoQuality == videoQuality &&
        other.videoLayout == videoLayout;
  }

  @override
  int get hashCode {
    return isLowBandwidthMode.hashCode ^
        isAudioMuted.hashCode ^
        echoCancellationEnabled.hashCode ^
        noiseSuppressionEnabled.hashCode ^
        agcEnabled.hashCode ^
        isVideoMuted.hashCode ^
        preferedCodec.hashCode ^
        videoQuality.hashCode ^
        videoLayout.hashCode;
  }
}

extension CallSettingX on CallSetting {
  Map<String, dynamic> get mediaConstraints {
    return {
      'audio': {
        'sampleRate': '48000',
        'sampleSize': '16',
        'channelCount': '1',
        'mandatory': audioMandatory,
        'optional': [],
      },
      'video': {
        'mandatory': videoQuality.videoProfile,
        'facingMode': 'user',
        'optional': [],
      },
    };
  }

  Map<String, String> get audioMandatory {
    return {
      'googEchoCancellation': '$echoCancellationEnabled',
      'googEchoCancellation2': '$echoCancellationEnabled',
      'googNoiseSuppression': '$noiseSuppressionEnabled',
      'googNoiseSuppression2': '$noiseSuppressionEnabled',
      'googAutoGainControl': '$agcEnabled',
      'googAutoGainControl2': '$agcEnabled',
      'googDAEchoCancellation': 'true',
      'googTypingNoiseDetection': 'true',
      'googAudioMirroring': 'false',
      'googHighpassFilter': 'true',
    };
  }
}
