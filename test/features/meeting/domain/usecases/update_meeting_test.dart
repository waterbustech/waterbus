// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/update_meeting.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late UpdateMeeting usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = UpdateMeeting(mockRepository);
  });

  final testMeeting = Meeting(title: 'Meeting with Kai');
  const testPassword = 'KaiDao';
  final createMeetingParams = CreateMeetingParams(
    meeting: testMeeting,
    password: testPassword,
  );

  test('should update a meeting for the given parameters', () async {
    // Arrange
    when(mockRepository.updateMeeting(any))
        .thenAnswer((_) async => Right(testMeeting));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, Right(testMeeting));
    verify(mockRepository.updateMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a Failure when the repository call fails', () async {
    // Arrange
    when(mockRepository.updateMeeting(any))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(createMeetingParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockRepository.updateMeeting(createMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
