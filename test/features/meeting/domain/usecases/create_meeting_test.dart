// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'create_meeting_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MeetingRepository>()])
void main() {
  late CreateMeeting usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = CreateMeeting(mockRepository);
  });

  const testMeeting = Meeting(title: 'Meeting with Kai');
  const testPassword = 'KaiDao';
  const createMeetingParams = CreateMeetingParams(
    meeting: testMeeting,
    password: testPassword,
  );

  test('should have correct props', () {
    // Arrange
    const param1 = CreateMeetingParams(
      meeting: testMeeting,
      password: testPassword,
    );
    const param2 = CreateMeetingParams(
      meeting: testMeeting,
      password: '${testPassword}01',
    );

    // Act & Assert
    expect(param1.props, [param1.meeting, param1.password]);
    expect(param2.props, [param2.meeting, param2.password]);
    expect(param1.props, isNot(equals(param2.props)));
  });

  test('should create a meeting for the given parameters', () async {
    // Arrange
    when(
      mockRepository.createMeeting(createMeetingParams),
    ).thenAnswer((_) async => const Right(testMeeting));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, const Right(testMeeting));
    verify(mockRepository.createMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when the repository call fails', () async {
    // Arrange
    when(mockRepository.createMeeting(createMeetingParams))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockRepository.createMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
