// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/usecases/clean_all_recent_joined.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late CleanAllRecentJoined usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = CleanAllRecentJoined(mockRepository);
  });

  test('should clean all success', () async {
    // Arrange
    when(mockRepository.cleanAllRecentJoined())
        .thenAnswer((_) => const Right(true));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right(true));
    verify(mockRepository.cleanAllRecentJoined());
    verifyNoMoreInteractions(mockRepository);
  });
}
