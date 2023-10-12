import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_participant.dart';

import 'create_meeting_test.mocks.dart';

void main() {
  late GetParticipant usecase;
  late MockMeetingRepository mockMeetingRepository;

  setUp(() {
    mockMeetingRepository = MockMeetingRepository();
    usecase = GetParticipant(mockMeetingRepository);
  });

  const tParticipantId = 1;
  final tParticipant = Participant(
    id: tParticipantId,
    role: MeetingRole.host,
    user: const User(id: 1, fullName: 'Kai', userName: 'Kai'),
  );

  test('should get a participant from the repository', () async {
    // Arrange
    when(mockMeetingRepository.getParticipantById(any))
        .thenAnswer((_) async => Right(tParticipant));

    // Act
    final result = await usecase(
      const GetPariticipantParams(
        participantId: tParticipantId,
      ),
    );

    // Assert
    expect(result, Right(tParticipant));
    verify(mockMeetingRepository.getParticipantById(tParticipantId));
    verifyNoMoreInteractions(mockMeetingRepository);
  });

  test('should return a Failure from the repository', () async {
    // Arrange
    final failure =
        ServerFailure(); // Replace with the appropriate failure type
    when(mockMeetingRepository.getParticipantById(any))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      const GetPariticipantParams(participantId: tParticipantId),
    );

    // Assert
    expect(result, Left(failure));
    verify(mockMeetingRepository.getParticipantById(tParticipantId));
    verifyNoMoreInteractions(mockMeetingRepository);
  });

  test('should have correct props', () {
    // Arrange
    const param1 = GetPariticipantParams(participantId: 1);
    const param2 = GetPariticipantParams(participantId: 2);

    // Act & Assert
    expect(param1.props, [param1.participantId]);
    expect(param2.props, [param2.participantId]);
    expect(param1.props, isNot(equals(param2.props)));
  });
}
