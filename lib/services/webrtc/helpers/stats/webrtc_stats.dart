// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:flutter_webrtc/flutter_webrtc.dart';

// Project imports:
import 'package:waterbus/core/types/extensions/duration_x.dart';
import 'package:waterbus/core/utils/path_helper.dart';

class WebRTCStatsUtility {
  RTCPeerConnection peerConnection;

  WebRTCStatsUtility(this.peerConnection);

  final List<double> _latencyMeasurements = [];
  final List<double> _avgLatencyMeasurements = [];
  final List<double> _bytesSentMeasurements = [];
  Timer? _statsTimer;

  void start() {
    // Clear any previous measurements
    _latencyMeasurements.clear();
    _avgLatencyMeasurements.clear();
    _bytesSentMeasurements.clear();

    // Start collecting stats periodically
    _statsTimer = Timer.periodic(1.seconds, (timer) {
      _collectStats();
    });
  }

  void stop() {
    _statsTimer?.cancel();
    _writeStatsToAsset();
  }

  Future<void> _collectStats() async {
    try {
      // Get the statistics
      final List<StatsReport> report = await peerConnection.getStats();

      // Calculate latency from the "remote-inbound-rtp" statistics
      for (final r in report) {
        if (r.values['kind'] == 'video' && r.values['roundTripTime'] != null) {
          final double roundTripTime = r.values['roundTripTime'] ?? 0;
          _latencyMeasurements.add(roundTripTime);
        }

        if (r.type == 'outbound-rtp' && r.values['kind'] == 'video') {
          // Access packet size information
          final int bytesSent = r.values['bytesSent'] ?? 0;

          // Convert bytes to KB
          final double kilobytesSent = bytesSent / 1024.0;

          _bytesSentMeasurements.add(kilobytesSent);
          _avgLatencyMeasurements.add(_calculateAverageLatency() * 1000);

          // Print packet size in KB
          debugPrint('Kilobytes Sent: $kilobytesSent KB');
        }
      }

      // Calculate and log the average latency
      final double averageLatency = _calculateAverageLatency() * 1000;
      debugPrint('Average Latency: $averageLatency ms');
    } catch (e) {
      debugPrint('Error collecting WebRTC stats: $e');
    }
  }

  double _calculateAverageLatency() {
    if (_latencyMeasurements.isEmpty) {
      return 0.0; // No measurements yet
    }
    final double totalLatency = _latencyMeasurements.reduce((a, b) => a + b);
    return totalLatency / _latencyMeasurements.length;
  }

  Future<void> _writeStatsToAsset() async {
    String stats = '''''';
    for (int index = 0; index < _bytesSentMeasurements.length; index++) {
      final double latency = _avgLatencyMeasurements[index] * 1000;
      stats += '''$index $latency ${_bytesSentMeasurements[index]}\n''';
    }

    final Directory path = await PathHelper.appDir;
    final filePath = File('${path.path}/benchmark.txt');

    // Write the asset content to the local file
    try {
      await filePath.create();
      await filePath.writeAsString(stats);
      debugPrint("Saved stats in ${filePath.path}");
    } catch (e) {
      debugPrint("Error writing data to the file: $e");
    }
  }
}
