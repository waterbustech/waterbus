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

  final testMeeting = Meeting(title: 'Meeting with Kai');
  const testPassword = 'KaiDao';
  final createMeetingParams =
      CreateMeetingParams(meeting: testMeeting, password: testPassword);

  test('should create a meeting for the given parameters', () async {
    // Arrange
    when(
      mockRepository.createMeeting(createMeetingParams),
    ).thenAnswer((_) async => Right(testMeeting));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, Right(testMeeting));
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
