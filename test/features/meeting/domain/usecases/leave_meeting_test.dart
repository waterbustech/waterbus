// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late LeaveMeeting leaveMeeting;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    leaveMeeting = LeaveMeeting(mockRepository);
  });

  const testMeetingCode = 123;
  const testParticipantId = 456;
  const leaveMeetingParams = LeaveMeetingParams(
    code: testMeetingCode,
    participantId: testParticipantId,
  );

  test('should have correct props', () {
    // Arrange
    const param1 = LeaveMeetingParams(
      code: 1,
      participantId: 2,
    );
    const param2 = LeaveMeetingParams(
      code: 1,
      participantId: 3,
    );

    // Act & Assert
    expect(param1.props, [param1.code, param1.participantId]);
    expect(param2.props, [param2.code, param2.participantId]);
    expect(param1.props, isNot(equals(param2.props)));
  });

  test('should call leaveMeeting on the repository with the given parameters',
      () async {
    // Arrange
    when(mockRepository.leaveMeeting(leaveMeetingParams))
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await leaveMeeting(leaveMeetingParams);

    // Assert
    expect(result, const Right(true));
    verify(mockRepository.leaveMeeting(leaveMeetingParams));
    verifyNoMoreInteractions(mockRepository);
  });
}
