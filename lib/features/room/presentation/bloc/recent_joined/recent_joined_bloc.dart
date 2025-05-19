import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/features/room/data/datasources/meeting_local_datasource.dart';

part 'recent_joined_event.dart';
part 'recent_joined_state.dart';

@injectable
class RecentJoinedBloc extends Bloc<RecentJoinedEvent, RecentJoinedState> {
  final List<Room> _recentRooms = [];
  final RoomLocalDataSource _localDataSource;

  RecentJoinedBloc(
    this._localDataSource,
  ) : super(RecentJoinedInitial()) {
    on<RecentJoinedEvent>(
      (event, emit) async {
        if (event is RecentJoinedStarted) {
          _handleGetRecentJoined();

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedInserted) {
          _insertMeeting(event.room);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedUpdated) {
          _findAndModifyRecent(event.room);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedRemoved) {
          _removeRoom(event.roomId);

          emit(_recentJoinedDone);
        }

        if (event is RecentJoinedCleaned) {
          _handleCleanAllRecentJoined();

          emit(_recentJoinedDone);
        }
      },
    );
  }

  // MARK: state
  RecentJoinedDone get _recentJoinedDone {
    _recentRooms.sort((pre, cur) {
      return cur.latestJoinedTime.compareTo(pre.latestJoinedTime);
    });

    return RecentJoinedDone(recentRooms: _recentRooms);
  }

  // MARK: private functions
  void _handleGetRecentJoined() {
    final List<Room> rooms = _localDataSource.rooms;

    if (rooms.isNotEmpty) {
      _recentRooms.clear();
      _recentRooms.addAll(rooms);
    }
  }

  void _handleCleanAllRecentJoined() {
    _localDataSource.removeAll();
    _recentRooms.clear();
  }

  void _insertMeeting(Room room) {
    final int indexOfRoom = _recentRooms.indexWhere(
      (item) => room.id == item.id,
    );

    if (indexOfRoom > -1) {
      _recentRooms.removeAt(indexOfRoom);
    }

    _recentRooms.insert(0, room);
  }

  void _removeRoom(int roomId) {
    final int indexOfRoom =
        _recentRooms.indexWhere((item) => item.id == roomId);

    if (indexOfRoom > -1) {
      _localDataSource.removeRoom(_recentRooms[indexOfRoom].id);
      _recentRooms.removeAt(indexOfRoom);
    }
  }

  void _findAndModifyRecent(Room room) {
    final int indexOfRoom = _recentRooms.indexWhere(
      (m) => m.id == room.id,
    );

    if (indexOfRoom == -1) return;

    _recentRooms[indexOfRoom] = room.copyWith(
      latestJoinedAt: _recentRooms[indexOfRoom].latestJoinedAt,
    );
  }

  // MARK: export
  List<Room> get recentRooms => _recentRooms;
}
