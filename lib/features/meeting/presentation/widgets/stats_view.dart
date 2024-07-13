import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';

typedef StatsData = List<VideoSenderStats>;

class StatsView extends StatefulWidget {
  const StatsView({super.key});

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final StreamController<StatsData> _statsStream =
      StreamController<StatsData>.broadcast();
  final StatsData _senderStats = [];

  @override
  void initState() {
    super.initState();
    WaterbusSdk.onStatsChanged = _handleOnStatsChanged;
  }

  @override
  void dispose() {
    WaterbusSdk.onStatsChanged = null;
    _statsStream.close();
    super.dispose();
  }

  void _handleOnStatsChanged(VideoSenderStats stats) {
    _senderStats.add(stats);
    _statsStream.add(_senderStats);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.callStats.i18n,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppNavigator.pop();
                },
                icon: Icon(
                  PhosphorIcons.x_circle_fill,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.sp),
          StreamBuilder<StatsData>(
            stream: _statsStream.stream,
            builder: (context, snapshot) {
              final VideoSenderStats? stats =
                  snapshot.hasData ? snapshot.data!.last : null;

              return Row(
                children: [
                  _buildStatsCell(
                    context,
                    title: Strings.frameSent.i18n,
                    value: stats?.framesSent.toString() ?? "NaN",
                  ),
                  SizedBox(width: 20.sp),
                  _buildStatsCell(
                    context,
                    title: Strings.resolution.i18n,
                    value:
                        "${stats?.frameWidth ?? 'NaN'}x${stats?.frameHeight ?? 'NaN'}",
                  ),
                  if (SizerUtil.isDesktop) SizedBox(width: 20.sp),
                  if (SizerUtil.isDesktop)
                    _buildStatsCell(
                      context,
                      title: "FPS",
                      value: stats?.framesPerSecond.toString() ?? "NaN",
                    ),
                ],
              );
            },
          ),
          SizedBox(height: 20.sp),
          SizedBox(
            width: double.infinity,
            child: _buildStatsChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCell(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Material(
        shape: SuperellipseShape(
          borderRadius: BorderRadius.circular(20.sp),
        ),
        color: Theme.of(context).colorScheme.primaryFixedDim,
        child: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsChart(BuildContext context) {
    return StreamBuilder<StatsData>(
      stream: _statsStream.stream,
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];

        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          // Enable legend
          legend: const Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<VideoSenderStats, String>>[
            LineSeries<VideoSenderStats, String>(
              dataSource: data,
              xValueMapper: (stats, index) => "${index * 2}",
              yValueMapper: (stats, _) =>
                  ((stats.roundTripTime ?? 0) * 1000).round(),
              name: Strings.latency.i18n,
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            LineSeries<VideoSenderStats, String>(
              dataSource: data,
              xValueMapper: (stats, index) => "${index * 2}",
              yValueMapper: (stats, _) => stats.jitter,
              name: 'jitter',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    );
  }
}
