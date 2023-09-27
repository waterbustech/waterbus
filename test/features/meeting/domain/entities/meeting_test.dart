// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'meeting_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserBloc>()])
void main() {
  late MockUserBloc mockUserBloc;

  setUpAll(() {
    final di = GetIt.instance;
    mockUserBloc = MockUserBloc();
    di.registerFactory<UserBloc>(() => mockUserBloc);
  });

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
        participants: [participant1],
        code: 1,
      );
      final Meeting meeting2 = Meeting(
        title: 'Meeting with Kai 2',
        id: 2,
        participants: [participant2],
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
      final Map<String, dynamic> map = meeting.toMapCreate(password);

      // Assert
      expect(map, isA<Map<String, dynamic>>());
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

  group('MeetingX', () {
    const user1 = User(id: 1, fullName: '1', userName: '1');
    const user2 = User(id: 2, fullName: '1', userName: '1');
    const user3 = User(id: 3, fullName: '1', userName: '1');

    final participant1 =
        Participant(user: user1, id: 1, role: MeetingRole.attendee);
    final participant2 =
        Participant(user: user2, id: 2, role: MeetingRole.attendee);
    final participant3 = Participant(
      user: user3,
      id: 3,
      role: MeetingRole.attendee,
      status: StatusEnum.inactive,
    );

    final meetingWithParticipants = Meeting(
      title: "Meeting with Kai",
      participants: [participant1, participant2, participant3],
    );

    final meetingWithoutParticipants = Meeting(
      participants: [],
      title: "Meeting with Kai",
    );

    test('should return active users', () {
      expect(meetingWithParticipants.users, [participant1, participant2]);
    });

    test('should return true for isNoOneElse when no users', () {
      expect(meetingWithoutParticipants.isNoOneElse, true);
    });

    test(
        'should return true for isNoOneElse when one user is the same as the current user',
        () {
      when(mockUserBloc.user).thenAnswer((realInvocation) => user1);

      expect(meetingWithoutParticipants.isNoOneElse, true);
    });

    test('should return false for isNoOneElse when multiple active users', () {
      expect(meetingWithParticipants.isNoOneElse, false);
    });
  });
}
