import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/gridview/custom_delegate.dart';
import 'package:waterbus/features/room/presentation/widgets/room_view.dart';

class RoomLayout extends StatefulWidget {
  final Room room;
  final MediaConfig mediaConfig;
  final CallState? callState;

  const RoomLayout({
    super.key,
    required this.room,
    required this.callState,
    required this.mediaConfig,
  });

  @override
  State<RoomLayout> createState() => _RoomLayoutState();
}

class _RoomLayoutState extends State<RoomLayout>
    with AutomaticKeepAliveClientMixin {
  // Cache participants list to avoid repeated computation
  List<ParticipantMediaState>? _cachedParticipants;
  String? _lastCallStateHash;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RepaintBoundary(
      child: Container(
        margin: context.isDesktop
            ? EdgeInsets.only(left: 20.sp, right: 4.sp)
            : EdgeInsets.symmetric(horizontal: 10.sp),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final participants = _getParticipants();
            final bool isCollapsed =
                constraints.maxHeight < 30.w && context.isDesktop;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: _buildLayout(
                context,
                participants,
                isCollapsed,
                constraints,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLayout(
    BuildContext context,
    List<ParticipantMediaState> participants,
    bool isCollapsed,
    BoxConstraints constraints,
  ) {
    if (isCollapsed) {
      return _buildLayoutMultipleUsersHorizontal(
        context,
        participants,
        constraints,
        key: ValueKey('horizontal_${participants.length}'),
      );
    } else if (participants.length > 2) {
      return _buildLayoutMultipleUsers(
        context,
        participants,
        constraints,
        key: ValueKey('grid_${participants.length}'),
      );
    } else {
      return _buildLayoutLess2Users(
        context,
        participants,
        constraints,
        key: ValueKey('dual_${participants.length}'),
      );
    }
  }

  // Memoized participants getter with caching
  List<ParticipantMediaState> _getParticipants() {
    // Create a simple hash of the call state to detect changes
    final currentHash = _generateCallStateHash();

    if (_cachedParticipants != null && _lastCallStateHash == currentHash) {
      return _cachedParticipants!;
    }

    _lastCallStateHash = currentHash;
    _cachedParticipants = _computeParticipants();

    return _cachedParticipants!;
  }

  String _generateCallStateHash() {
    final buffer = StringBuffer();

    // Include main participant
    if (widget.callState?.mParticipant != null) {
      final p = widget.callState!.mParticipant!;
      buffer.write(
        '${p.ownerId}_${p.isSharingScreen}_${p.isVideoEnabled}_${p.isAudioEnabled}',
      );
    }

    // Include other participants
    for (final p
        in widget.callState?.participants.values ?? <ParticipantMediaState>[]) {
      buffer.write(
        '${p.ownerId}_${p.isSharingScreen}_${p.isVideoEnabled}_${p.isAudioEnabled}',
      );
    }

    return buffer.toString();
  }

  List<ParticipantMediaState> _computeParticipants() {
    final List<ParticipantMediaState> participants = [];

    // Add main participant
    if (widget.callState?.mParticipant != null) {
      final ParticipantMediaState participant = widget.callState!.mParticipant!;
      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    // Add other participants
    for (final ParticipantMediaState participant
        in widget.callState?.participants.values ?? <ParticipantMediaState>[]) {
      participants.add(participant.copyWith(isSharingScreen: false));

      if (participant.isSharingScreen) {
        participants.add(participant);
      }
    }

    return participants;
  }

  Widget _buildLayoutLess2Users(
    BuildContext context,
    List<ParticipantMediaState> participants,
    BoxConstraints constraints, {
    Key? key,
  }) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;

    final List<Widget> children = [
      Expanded(
        flex: participants.length > 1 ? 1 : 2,
        child: AnimatedContainer(
          duration: 300.milliseconds,
          width: context.isDesktop
              ? (participants.length > 1 ? width / 2 : width)
              : double.infinity,
          height: context.isDesktop
              ? double.infinity
              : (participants.length > 1 ? height / 2 : height),
          curve: Curves.easeInOut,
          child: RoomView(
            key: ValueKey('room_${participants.first.ownerId}_0'),
            participants: widget.room.participants,
            participantSFU: participants.first,
            borderEnabled: participants.length > 1 || context.isMobile,
          ),
        ),
      ),
      if (context.isDesktop) SizedBox(width: 12.sp),
      participants.length == 1
          ? const SizedBox()
          : Expanded(
              child: AnimatedContainer(
                duration: 300.milliseconds,
                width: context.isDesktop
                    ? (participants.length > 1 ? width / 2 : width)
                    : double.infinity,
                height: context.isDesktop
                    ? double.infinity
                    : (participants.length > 1 ? height / 2 : height),
                curve: Curves.easeInOut,
                child: RoomView(
                  key: ValueKey('room_${participants.last.ownerId}_1'),
                  participants: widget.room.participants,
                  participantSFU: participants.last,
                ),
              ),
            ),
    ];

    return Container(
      key: key,
      child: context.isDesktop
          ? Center(
              child: SizedBox(
                height: participants.length == 1
                    ? constraints.maxHeight
                    : constraints.maxHeight * 0.5,
                child: Row(children: children),
              ),
            )
          : Column(children: children),
    );
  }

  Widget _buildLayoutMultipleUsers(
    BuildContext context,
    List<ParticipantMediaState> participants,
    BoxConstraints constraints, {
    Key? key,
  }) {
    final crossAxisCount =
        _gridCount(participants.length, constraints.maxWidth);

    return Container(
      key: key,
      child: GridView.builder(
        key: ValueKey('grid_${participants.length}_$crossAxisCount'),
        itemCount: participants.length,
        cacheExtent: 1000, // Cache more items to reduce rebuilds
        itemBuilder: (_, index) {
          final participant = participants[index];
          return RepaintBoundary(
            child: _buildVideoView(
              context,
              participant: participant,
              callState: widget.callState,
              avatarSize: context.isDesktop ? 50.sp : 35.sp,
              key: ValueKey('grid_item_${participant.ownerId}_$index'),
            ),
          );
        },
        padding: EdgeInsets.only(right: context.isDesktop ? 20.sp : 0),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCountAndCentralizedLastElement(
          itemCount:
              crossAxisCount < 2 && context.isDesktop ? 2 : participants.length,
          crossAxisCount: context.isDesktop ? crossAxisCount : 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: context.isDesktop
              ? (participants.length <= 6 && crossAxisCount == 3 ? k43 : k169)
              : (participants.length < 6 ? k35 : k11),
        ),
      ),
    );
  }

  Widget _buildLayoutMultipleUsersHorizontal(
    BuildContext context,
    List<ParticipantMediaState> participants,
    BoxConstraints constraints, {
    Key? key,
  }) {
    return Container(
      key: key,
      child: ListView.builder(
        key: ValueKey('horizontal_${participants.length}'),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: participants.length,
        cacheExtent: 1000,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          final participant = participants[index];
          return RepaintBoundary(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _buildVideoView(
                context,
                participant: participant,
                callState: widget.callState,
                avatarSize: context.isDesktop ? 50.sp : 35.sp,
                key: ValueKey('horizontal_item_${participant.ownerId}_$index'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoView(
    BuildContext context, {
    required ParticipantMediaState participant,
    required CallState? callState,
    double? width,
    double avatarSize = 35,
    Key? key,
  }) {
    return RoomView(
      key: key,
      participants: widget.room.participants,
      participantSFU: participant,
      avatarSize: avatarSize,
      width: width,
    );
  }

  int _gridCount(int number, double width) {
    if (width / 300.sp < 2) return 1;
    if (number <= 4) return 2;
    return 3;
  }
}
