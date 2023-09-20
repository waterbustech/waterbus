import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';

import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('Meeting entity', () {
    test(
      'should be a subclass of Meeting entity',
      () {},
    );

    test('operator ==', () {
      const User userModel = User(
        id: 1,
        userName: 'lambiengcode',
        fullName: 'Kai',
      );
      final participant1 = Participant(
        id: 1,
        role: MeetingRole.attendee,
        user: userModel,
      );
      final participant2 = Participant(
        id: 2,
        role: MeetingRole.host,
        user: userModel,
      );

      final Meeting meeting1 = Meeting(
        title: 'Meeting with Kai 1',
        id: 1,
        users: [participant1],
        code: 1,
      );
      final Meeting meeting2 = Meeting(
        title: 'Meeting with Kai 2',
        id: 2,
        users: [participant2],
        code: 2,
      );

      // Act
      final Meeting meeting = meeting1.copyWith();

      // Assert
      expect(meeting.title == meeting1.title, true);
      expect(meeting == meeting1, true);
      expect(meeting == meeting2, false);
    });

    test('copyWith - should return a new instance with the specified changes',
        () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final Meeting updatedMeeting = meeting.copyWith(
        title: 'Updated Meeting',
        id: 0,
      );

      // Assert
      expect(updatedMeeting.title, 'Updated Meeting');
    });

    test('toString - should return a string representation of the Meeting', () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final String meetingString = meeting.toString();

      // Assert
      expect(meetingString, contains('Meeting'));
      expect(meetingString, contains(meeting.title));
    });

    test('hashCode - should return the hash code of the Meeting', () {
      // Arrange
      final Map<String, dynamic> meetingSampleJson =
          jsonDecode(fixture(meetingSample));

      // Act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);
      final int hashCode = meeting.hashCode;

      // Assert
      expect(hashCode, isA<int>());
    });

    test('toMapCreate - should return a map for creating a Meeting', () {
      // Arrange
      final Meeting meeting = Meeting(title: 'Sample Meeting');
      const String password = 'sample_password';

      // Act
      final Map<String, String> map = meeting.toMapCreate(password);

      // Assert
      expect(map, isA<Map<String, String>>());
      expect(map['title'], 'Sample Meeting');
      expect(map['password'], 'sample_password');
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // Arrange
        final Map<String, dynamic> meetingSampleJson =
            jsonDecode(fixture(meetingSample));

        // Act
        final Meeting meeting = Meeting.fromMap(meetingSampleJson);

        // Assert
        expect(meeting, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String meetingSampleJson = fixture(meetingSample);

        // Act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // Assert
        expect(meeting, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // Arrange
        final String meetingSampleJson = fixture(meetingSample);

        // Act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // Assert
        expect(meeting.toJson(), isNotNull);
      },
    );
  });
}
