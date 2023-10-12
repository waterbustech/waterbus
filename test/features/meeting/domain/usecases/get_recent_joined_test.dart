// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_recent_joined.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late GetRecentJoined usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = GetRecentJoined(mockRepository);
  });

  // Test that when the usecase is called, it should call the repository's getRecentJoined() method and return data
  test('should get a list of meetings from the repository', () async {
    // Arrange
    final List<Meeting> meetings = [
      const Meeting(title: 'Kai'),
    ];
    when(mockRepository.getRecentJoined())
        .thenAnswer((_) async => Right(meetings));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Right(meetings));
    verify(mockRepository.getRecentJoined());
    verifyNoMoreInteractions(mockRepository);
  });
}
