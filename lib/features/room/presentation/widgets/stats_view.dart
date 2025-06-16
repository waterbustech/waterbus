import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/navigator/app_router.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';

typedef StatsData = RtcParticipantStats;
typedef StatsChartData = (List<num> jitters, List<num> rtts);

class StatsView extends StatefulWidget {
  final CallState? callState;
  final List<Participant> participants;
  const StatsView({
    super.key,
    required this.callState,
    required this.participants,
  });

  @override
  State<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  final StreamController<StatsChartData> _statsChartController =
      StreamController.broadcast();
  final List<num> _roundTimeTrips = [];
  final List<num> _jitters = [];
  final List<ParticipantMediaState> _participants = [];
  Stream<StatsData>? _statsStream;
  String _currentStats = '';

  @override
  void initState() {
    super.initState();

    _participants.addAll(_participantMediaStates);

    if (_participants.isEmpty) return;

    final statsId =
        '${_participants.first.ownerId}_${_participants.first.isSharingScreen}';
    _setStatsStream(_participants.first.webcamStatsStream, statsId);
  }

  @override
  void dispose() {
    _statsChartController.close();
    super.dispose();
  }

  void _setStatsStream(
    Stream<RtcParticipantStats>? stream,
    String statsId,
  ) {
    _roundTimeTrips.clear();
    _jitters.clear();
    _currentStats = statsId;

    _statsChartController.sink.add(([], []));

    _statsStream = stream;

    if (mounted) setState(() {});

    _statsStream?.listen((stats) {
      _roundTimeTrips.add(stats.roundTripTime ?? 0);
      _jitters.add(stats.jitter ?? 0);

      _statsChartController.sink.add((_jitters, _roundTimeTrips));
    });
  }

  List<ParticipantMediaState> get _participantMediaStates {
    final List<ParticipantMediaState> participants = [];
    if (widget.callState?.mParticipant != null) {
      final ParticipantMediaState participant = widget.callState!.mParticipant!;

      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    final trackParticipants =
        widget.callState?.participants.values.toList() ?? [];

    for (final ParticipantMediaState participant in trackParticipants) {
      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    return participants;
  }

  Participant? _getParticipant(ParticipantMediaState participantMediaState) {
    final participants = widget.participants;

    if (participantMediaState.ownerId == kIsMine) {
      return participants.firstWhereOrNull((participant) => participant.isMe);
    }

    return participants.firstWhereOrNull(
      (participant) =>
          participant.id.toString() == participantMediaState.ownerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.sp),
            child: Row(
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
                    AppRouter.pop();
                  },
                  icon: Icon(
                    PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
                    size: 20.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.sp),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 160.sp,
                  height: double.infinity,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: _participants.length,
                    itemBuilder: (context, index) {
                      final participant = _getParticipant(_participants[index]);
                      final statsId =
                          '${_participants[index].ownerId}_${_participants[index].isSharingScreen}';

                      final isSelecting = _currentStats == statsId;
                      final isMe = _participants[index].ownerId == kIsMine;

                      return GestureWrapper(
                        onTap: () {
                          if (isSelecting) return;

                          if (_participants[index].isSharingScreen) {
                            _setStatsStream(
                              _participants[index].screenStatsStream,
                              statsId,
                            );
                          } else {
                            _setStatsStream(
                              _participants[index].webcamStatsStream,
                              statsId,
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelecting
                                ? Theme.of(context).colorScheme.surfaceContainer
                                : null,
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.sp,
                            vertical: 10.sp,
                          ),
                          child: Row(
                            spacing: 10.sp,
                            children: [
                              AvatarCard(
                                urlToImage: participant?.user?.avatar,
                                size: 26.sp,
                                label: participant?.user?.userName,
                              ),
                              Expanded(
                                child: Text(
                                  '${isMe ? 'You' : (participant?.user?.fullName ?? 'Waterbus')} '
                                  '(${_participants[index].isSharingScreen ? 'Screen' : 'Webcam'})',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.sp),
                  child: const VerticalDivider(),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.sp),
                        child: StreamBuilder<StatsData>(
                          stream: _statsStream,
                          builder: (context, snapshot) {
                            final stats = snapshot.data;

                            return Row(
                              children: [
                                _buildStatsCell(
                                  context,
                                  title: 'Packet Losts',
                                  value: stats?.packetsLost.toString() ?? "NaN",
                                ),
                                SizedBox(width: 20.sp),
                                _buildStatsCell(
                                  context,
                                  title: _currentStats.startsWith(kIsMine)
                                      ? 'Frame Sent'
                                      : 'Frame Received',
                                  value: (_currentStats.startsWith(kIsMine)
                                          ? stats?.framesSent.toString()
                                          : stats?.framesReceived.toString()) ??
                                      "NaN",
                                ),
                                if (context.isDesktop) SizedBox(width: 20.sp),
                                if (context.isDesktop)
                                  _buildStatsCell(
                                    context,
                                    title: "Bitrate",
                                    value:
                                        "${stats?.bitrate?.toStringAsFixed(2) ?? "NaN"} Kbps",
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      Expanded(
                        child: _buildStatsChart(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    return StreamBuilder<StatsChartData>(
      stream: _statsChartController.stream,
      builder: (context, snapshot) {
        final jitters = snapshot.data?.$1 ?? [];
        final roundTimeTrips = snapshot.data?.$2 ?? [];

        if (jitters.length != roundTimeTrips.length || jitters.isEmpty) {
          return const SizedBox();
        }

        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          // Enable legend
          legend: const Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<num, String>>[
            LineSeries<num, String>(
              dataSource: roundTimeTrips,
              xValueMapper: (stats, index) => "${index * 2}",
              yValueMapper: (rtt, _) => (rtt * 1000).round(),
              name: Strings.latency.i18n,
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
            LineSeries<num, String>(
              dataSource: jitters,
              xValueMapper: (stats, index) => "${index * 2}",
              yValueMapper: (jitter, _) => (jitter * 1000).round(),
              name: 'jitter (ms)',
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    );
  }
}
