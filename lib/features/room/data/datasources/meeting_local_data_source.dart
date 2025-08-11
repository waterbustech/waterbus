import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/constants/storage_keys.dart';

abstract class RoomLocalDataSource {
  void insertOrUpdate(Room room);
  void update(Room room);
  List<Room> get rooms;
  void removeRoom(int roomId);
  void removeAll();
}

@LazySingleton(as: RoomLocalDataSource)
class RoomLocalDataSourceImpl extends RoomLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxRoom);

  @override
  void insertOrUpdate(Room room) {
    final List<Room> roomList = rooms;

    final int indexOfRoom = roomList.indexWhere((item) => item.id == room.id);

    if (indexOfRoom != -1) {
      roomList.removeAt(indexOfRoom);
    } else {}

    roomList.insert(0, room);

    _saveRoomsList(roomList);
  }

  @override
  List<Room> get rooms {
    final List roomList = hiveBox.get(
      StorageKeys.rooms,
      defaultValue: [],
    );

    return roomList
        .map((roomJson) => Room.fromJson(jsonDecode(roomJson)))
        .toList();
  }

  @override
  void removeAll() {
    hiveBox.delete(StorageKeys.rooms);
  }

  @override
  void removeRoom(int roomId) {
    final List<Room> roomList = rooms;
    roomList.removeWhere((room) => room.id == roomId);

    _saveRoomsList(roomList);
  }

  @override
  void update(Room room) {
    final List<Room> roomList = rooms;

    final int indexOfRoom = roomList.indexWhere((item) => item.id == room.id);

    if (indexOfRoom == -1) return;

    roomList[indexOfRoom] = room;

    _saveRoomsList(rooms);
  }

  // MARK: private functions
  void _saveRoomsList(List<Room> rooms) {
    hiveBox.put(
      StorageKeys.rooms,
      rooms.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
