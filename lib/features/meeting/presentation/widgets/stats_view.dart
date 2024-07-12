import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';

final List<StatsData> data = [
  StatsData(1, 10),
  StatsData(2, 14),
  StatsData(3, 12),
  StatsData(4, 8),
  StatsData(5, 17),
];

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stats",
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
          Row(
            children: [
              _buildStatsCell(context, title: "Frame Sent", value: "5559"),
              SizedBox(width: 20.sp),
              _buildStatsCell(context, title: "Frame Size", value: "480x360"),
              SizedBox(width: 20.sp),
              _buildStatsCell(context, title: "FPS", value: "15"),
            ],
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
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      // Chart title
      title: const ChartTitle(text: 'Latency'),
      // Enable legend
      legend: const Legend(isVisible: true),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<StatsData, String>>[
        LineSeries<StatsData, String>(
          dataSource: data,
          xValueMapper: (stats, _) => stats.time.toString(),
          yValueMapper: (sales, _) => sales.value,
          name: 'ms',
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        LineSeries<StatsData, String>(
          dataSource: data,
          xValueMapper: (stats, _) => stats.time.toString(),
          yValueMapper: (sales, _) => sales.value + 2,
          name: 'buffer',
          // Enable data label
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class StatsData {
  final int time;
  final int value;

  StatsData(this.time, this.value);
}
