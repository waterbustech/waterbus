// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_local_datasource.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_remote_datasource.dart';
import 'package:waterbus/features/meeting/data/repositories/meeting_repository_impl.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'meeting_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MeetingRemoteDataSource>(),
  MockSpec<MeetingLocalDataSource>(),
  MockSpec<UserBloc>(),
])
void main() {
  late MeetingRepositoryImpl repository;
  late MockMeetingRemoteDataSource mockRemoteDataSource;
  late MockMeetingLocalDataSource mockLocalDataSource;
  late MockUserBloc mockUserBloc;

  setUpAll(() {
    final di = GetIt.instance;
    mockUserBloc = MockUserBloc();
    di.registerFactory<UserBloc>(() => mockUserBloc);
  });

  setUp(() {
    mockRemoteDataSource = MockMeetingRemoteDataSource();
    mockLocalDataSource = MockMeetingLocalDataSource();
    repository =
        MeetingRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  final testMeeting = Meeting(title: 'Meeting with Kai');
  const testPassword = 'KaiDao';
  final createMeetingParams =
      CreateMeetingParams(meeting: testMeeting, password: testPassword);
  const getMeetingParams = GetMeetingParams(code: 1);
  const leaveMeetingParams = LeaveMeetingParams(
    code: 1,
    participantId: 123,
  );

  group('createMeeting', () {
    test('should return a Meeting when the remote call is successful',
        () async {
      // Arrange
      when(
        mockRemoteDataSource.createMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testMeeting);

      // Act
      final result = await repository.createMeeting(createMeetingParams);

      // Assert
      expect(result, Right(testMeeting));
      verify(
        mockRemoteDataSource.createMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verify(mockLocalDataSource.insertOrUpdate(testMeeting));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a NullValue when the remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.createMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.createMeeting(createMeetingParams);

      // Assert
      expect(result, Left(NullValue()));
      verify(
        mockRemoteDataSource.createMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('getInfoMeeting', () {
    test('should return a Meeting when the remote call is successful',
        () async {
      // Arrange
      when(mockRemoteDataSource.getInfoMeeting(any))
          .thenAnswer((_) async => testMeeting);

      // Act
      final result = await repository.getInfoMeeting(getMeetingParams);

      // Assert
      expect(result, Right(testMeeting));
      verify(mockRemoteDataSource.getInfoMeeting(getMeetingParams.code));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return a NullValue when the remote call fails', () async {
      // Arrange
      when(mockRemoteDataSource.getInfoMeeting(any))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getInfoMeeting(getMeetingParams);

      // Assert
      expect(result, Left(NullValue()));
      verify(mockRemoteDataSource.getInfoMeeting(getMeetingParams.code));
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('joinMeeting', () {
    test('should return a Meeting when the remote call is successful',
        () async {
      // Arrange
      when(
        mockRemoteDataSource.joinMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testMeeting);

      // Act
      final result = await repository.joinMeeting(createMeetingParams);

      // Assert
      expect(result, Right(testMeeting));
      verify(
        mockRemoteDataSource.joinMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verify(mockLocalDataSource.insertOrUpdate(testMeeting));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a NullValue when the remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.joinMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.joinMeeting(createMeetingParams);

      // Assert
      expect(result, Left(NullValue()));
      verify(
        mockRemoteDataSource.joinMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('updateMeeting', () {
    test('should return a Meeting when the remote call is successful',
        () async {
      // Arrange
      when(
        mockRemoteDataSource.updateMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.updateMeeting(createMeetingParams);

      // Assert
      expect(result, Right(testMeeting));
      verify(
        mockRemoteDataSource.updateMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verify(mockLocalDataSource.insertOrUpdate(testMeeting));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return a NullValue when the remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.updateMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.updateMeeting(createMeetingParams);

      // Assert
      expect(result, Left(NullValue()));
      verify(
        mockRemoteDataSource.updateMeeting(
          meeting: testMeeting,
          password: testPassword,
        ),
      );
      verifyZeroInteractions(mockLocalDataSource);
    });
  });

  group('leaveMeeting', () {
    test('should return true when the remote call is successful', () async {
      // Arrange
      final Meeting testMeeting = Meeting(title: "Meeting with Kai");
      when(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      ).thenAnswer((_) async => testMeeting);

      // Act
      final result = await repository.leaveMeeting(leaveMeetingParams);

      // Assert
      expect(result, Right(testMeeting));
      verify(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      );
      verify(mockLocalDataSource.update(testMeeting));
      verifyNever(mockLocalDataSource.removeMeeting(leaveMeetingParams.code));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return false when the remote call fails', () async {
      // Arrange
      when(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.leaveMeeting(leaveMeetingParams);

      // Assert
      expect(result, Left(NullValue()));
      verify(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      );
      verifyNever(mockLocalDataSource.update(testMeeting));
      verifyNever(mockLocalDataSource.removeMeeting(leaveMeetingParams.code));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('recent joined meetings', () {
    test(
        'should return a list of recent joined meetings from local data source',
        () async {
      final testMeetings = [
        Meeting(id: 1, title: 'Meeting 1', code: 123),
        Meeting(id: 2, title: 'Meeting 2', code: 456),
      ];
      // Arrange
      when(mockLocalDataSource.meetings).thenReturn(testMeetings);

      // Act
      final result = await repository.getRecentJoined();

      // Assert
      expect(result, Right(testMeetings));
      verify(mockLocalDataSource.meetings);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('local data source should remove all recent joined meetings',
        () async {
      // Arrange
      when(mockLocalDataSource.removeAll()).thenReturn(null);

      // Act
      final result = repository.cleanAllRecentJoined();

      // Assert
      expect(result, const Right(true));
      verify(mockLocalDataSource.removeAll());
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('getParticipantById', () {
    test(
        'getParticipantById - should return a Participant when the remote call is successful',
        () async {
      // Arrange
      const participantId = 123;
      final participant = Participant(
        id: participantId,
        role: MeetingRole.attendee,
        user: const User(
          id: 1,
          fullName: 'Kai',
          userName: 'kai',
        ),
      );
      when(mockRemoteDataSource.getParticipant(participantId))
          .thenAnswer((_) async => participant);

      // Act
      final result = await repository.getParticipantById(participantId);

      // Assert
      expect(result, Right(participant));
      verify(mockRemoteDataSource.getParticipant(participantId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test(
        'getParticipantById - should return a NullValue when the remote call fails',
        () async {
      // Arrange
      const participantId = 123;
      when(mockRemoteDataSource.getParticipant(participantId))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getParticipantById(participantId);

      // Assert
      expect(result, Left(NullValue()));
      verify(mockRemoteDataSource.getParticipant(participantId));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('findMyParticipantObject', () {
    test('should set isMe to true for the current user', () {
      // Arrange
      const user1 = User(id: 1, userName: '1', fullName: '1');
      const user2 = User(id: 2, userName: '2', fullName: '2');
      final currentUserMeeting = Meeting(
        title: 'Meeting with Kai',
        participants: [
          Participant(user: user1, id: 1, role: MeetingRole.attendee),
          Participant(user: user2, id: 2, role: MeetingRole.attendee),
        ],
      );

      when(mockUserBloc.user).thenAnswer((realInvocation) => user1);

      // Act
      final updatedMeeting = repository.findMyParticipantObject(
        currentUserMeeting,
        participantId: 1,
      );

      // Assert
      expect(updatedMeeting.participants.where((p) => p.isMe).length, 1);
      expect(
        updatedMeeting.participants.firstWhere((p) => p.isMe).user.id,
        1,
      );
    });

    test('should not modify meeting if current user is not found', () {
      // Arrange
      const user1 = User(id: 1, userName: '1', fullName: '1');
      const user2 = User(id: 2, userName: '2', fullName: '2');
      const user3 = User(id: 3, userName: '2', fullName: '2');
      final currentUserMeeting = Meeting(
        title: 'Meeting with Kai',
        participants: [
          Participant(user: user1, id: 1, role: MeetingRole.attendee),
          Participant(user: user2, id: 2, role: MeetingRole.attendee),
        ],
      );

      when(mockUserBloc.user).thenAnswer((realInvocation) => user3);

      // Act
      final updatedMeeting = repository.findMyParticipantObject(
        currentUserMeeting,
      );

      // Assert
      expect(updatedMeeting.participants.where((p) => p.isMe).isEmpty, true);
    });
  });
}
