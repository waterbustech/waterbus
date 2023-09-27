// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/storage_keys.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';

abstract class MeetingLocalDataSource {
  void insertOrUpdate(Meeting meeting);
  void update(Meeting meeting);
  List<Meeting> get meetings;
  void removeMeeting(int code);
  void removeAll();
}

@LazySingleton(as: MeetingLocalDataSource)
class MeetingLocalDataSourceImpl extends MeetingLocalDataSource {
  final Box hiveBox = Hive.box(StorageKeys.boxMeeting);

  @override
  void insertOrUpdate(Meeting meeting) {
    final List<Meeting> meetingsList = meetings;

    final int indexOfMeeting = meetingsList.indexWhere(
      (meetX) => meetX.id == meeting.id,
    );

    if (indexOfMeeting != -1) {
      meetingsList.removeAt(indexOfMeeting);
    } else {}

    meetingsList.insert(0, meeting);

    _saveMeetingsList(meetingsList);
  }

  @override
  List<Meeting> get meetings {
    final List meetingsList = hiveBox.get(
      StorageKeys.meetings,
      defaultValue: [],
    );
    return meetingsList
        .map((meetingJson) => Meeting.fromJson(meetingJson))
        .toList();
  }

  @override
  void removeAll() {
    hiveBox.delete(StorageKeys.meetings);
  }

  @override
  void removeMeeting(int code) {
    final List<Meeting> meetingsList = meetings;
    meetingsList.removeWhere((meeting) => meeting.code == code);

    _saveMeetingsList(meetingsList);
  }

  @override
  void update(Meeting meeting) {
    final List<Meeting> meetingsList = meetings;

    final int indexOfMeeting = meetingsList.indexWhere(
      (meetX) => meetX.id == meeting.id,
    );

    if (indexOfMeeting == -1) return;

    meetingsList[indexOfMeeting] = meeting;

    _saveMeetingsList(meetings);
  }

  // MARK: private functions
  void _saveMeetingsList(List<Meeting> meetings) {
    hiveBox.put(
      StorageKeys.meetings,
      meetings.map((meeting) => meeting.toJson()).toList(),
    );
  }
}
