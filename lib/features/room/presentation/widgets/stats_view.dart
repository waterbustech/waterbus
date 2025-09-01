import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';

typedef StatsData = RtcParticipantStats;
typedef StatsChartData = (List<num> jitters, List<num> rtts);

class StatsView extends StatefulWidget {
  final Participant participant;
  final bool isScreenShare;

  const StatsView({
    super.key,
    required this.participant,
    this.isScreenShare = false,
  });

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final StreamController<StatsChartData> _statsChartController =
      StreamController.broadcast();
  final List<num> _roundTimeTrips = [];
  final List<num> _jitters = [];
  Stream<StatsData>? _statsStream;
  StreamSubscription<StatsData>? _statsSubscription;

  // Shadcn-inspired dark theme colors
  static const Color _background = Color(0xFF0A0A0A);
  static const Color _card = Color(0xFF111111);
  static const Color _border = Color(0xFF262626);
  static const Color _primary = Color(0xFFFAFAFA);
  static const Color _secondary = Color(0xFF737373);
  static const Color _muted = Color(0xFF404040);
  static const Color _accent = Color(0xFF18181B);

  @override
  void initState() {
    super.initState();
    _setStatsStream();
  }

  @override
  void dispose() {
    // Properly close streams and subscriptions
    _statsSubscription?.cancel();
    _statsChartController.close();
    super.dispose();
  }

  void _setStatsStream() {
    _roundTimeTrips.clear();
    _jitters.clear();

    _statsChartController.sink.add(([], []));

    _statsStream = widget.isScreenShare
        ? widget.participant.screenStatsStream
        : widget.participant.webcamStatsStream;

    if (mounted) setState(() {});

    // Store subscription for proper disposal
    _statsSubscription = _statsStream?.listen((stats) {
      if (mounted) {
        _roundTimeTrips.add(stats.roundTripTime ?? 0);
        _jitters.add(stats.jitter ?? 0);

        _statsChartController.sink.add((_jitters, _roundTimeTrips));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _background,
        border: Border.all(color: _border),
      ),
      padding: EdgeInsets.all(20.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.sp),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatsGrid(context),
                SizedBox(height: 24.sp),
                Expanded(child: _buildStatsChart(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Strings.callStats.i18n,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: _primary,
            letterSpacing: -0.02,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8.sp),
            onTap: () => AppRouter.pop(),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(8.sp),
                border: Border.all(color: _border),
              ),
              child: Icon(
                PhosphorIcons.x(),
                size: 16.sp,
                color: _secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return StreamBuilder<StatsData>(
      stream: _statsStream,
      builder: (context, snapshot) {
        final stats = snapshot.data;

        return Row(
          children: [
            _buildStatsCard(
              context,
              title: 'Packet Loss',
              value: stats?.packetsLost.toString() ?? "—",
              subtitle: 'packets',
            ),
            SizedBox(width: 16.sp),
            _buildStatsCard(
              context,
              title: widget.participant is LocalParticipant
                  ? 'Frames Sent'
                  : 'Frames Received',
              value: (widget.participant is LocalParticipant
                      ? stats?.framesSent.toString()
                      : stats?.framesReceived.toString()) ??
                  "—",
              subtitle: 'frames',
            ),
            if (context.isDesktop) SizedBox(width: 16.sp),
            if (context.isDesktop)
              _buildStatsCard(
                context,
                title: "Bitrate",
                value: stats?.bitrate?.toStringAsFixed(1) ?? "—",
                subtitle: 'kbps',
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(8.sp),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _secondary,
                letterSpacing: 0.01,
              ),
            ),
            SizedBox(height: 8.sp),
            Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: _primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(width: 4.sp),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: _secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsChart(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: _border),
      ),
      child: StreamBuilder<StatsChartData>(
        stream: _statsChartController.stream,
        builder: (context, snapshot) {
          final jitters = snapshot.data?.$1 ?? [];
          final roundTimeTrips = snapshot.data?.$2 ?? [];

          if (jitters.length != roundTimeTrips.length || jitters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.chartLine(),
                    size: 32.sp,
                    color: _muted,
                  ),
                  SizedBox(height: 12.sp),
                  Text(
                    'Waiting for data...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _secondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Network Performance',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: _primary,
                ),
              ),
              SizedBox(height: 8.sp),
              Row(
                children: [
                  _buildLegendItem('Latency', const Color(0xFF3B82F6)),
                  SizedBox(width: 24.sp),
                  _buildLegendItem('Jitter', const Color(0xFFEF4444)),
                ],
              ),
              SizedBox(height: 16.sp),
              Expanded(
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: _border,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40.sp,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}ms',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: _secondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24.sp,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt() * 2}s',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: _secondary,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                    ),
                    lineBarsData: [
                      // Latency line
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < roundTimeTrips.length; i++)
                            FlSpot(
                              i.toDouble(),
                              (roundTimeTrips[i] * 1000).roundToDouble(),
                            ),
                        ],
                        isCurved: true,
                        color: const Color(0xFF3B82F6),
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF3B82F6).withValues(alpha: .1),
                        ),
                      ),
                      // Jitter line
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < jitters.length; i++)
                            FlSpot(
                              i.toDouble(),
                              (jitters[i] * 1000).roundToDouble(),
                            ),
                        ],
                        isCurved: true,
                        color: const Color(0xFFEF4444),
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFFEF4444).withValues(alpha: .1),
                        ),
                      ),
                    ],
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: _border),
                        bottom: BorderSide(color: _border),
                      ),
                    ),
                    minX: 0,
                    maxX: (roundTimeTrips.length - 1).toDouble(),
                    minY: 0,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.sp,
          height: 8.sp,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.sp),
          ),
        ),
        SizedBox(width: 6.sp),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: _secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
