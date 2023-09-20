// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_local_datasource.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_remote_datasource.dart';
import 'package:waterbus/features/meeting/data/repositories/meeting_repository_impl.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'meeting_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MeetingRemoteDataSource>(),
  MockSpec<MeetingLocalDataSource>(),
])
void main() {
  late MeetingRepositoryImpl repository;
  late MockMeetingRemoteDataSource mockRemoteDataSource;
  late MockMeetingLocalDataSource mockLocalDataSource;

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
      ).thenAnswer((_) async => testMeeting);

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
      ).thenAnswer((_) async => null);

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
      when(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.leaveMeeting(leaveMeetingParams);

      // Assert
      expect(result, const Right(true));
      verify(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      );
      verify(mockLocalDataSource.removeMeeting(leaveMeetingParams.code));
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
      ).thenAnswer((_) async => false);

      // Act
      final result = await repository.leaveMeeting(leaveMeetingParams);

      // Assert
      expect(result, const Right(false));
      verify(
        mockRemoteDataSource.leaveMeeting(
          code: leaveMeetingParams.code,
          participantId: leaveMeetingParams.participantId,
        ),
      );
      verifyNever(mockLocalDataSource.removeMeeting(leaveMeetingParams.code));
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

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
  });
}
