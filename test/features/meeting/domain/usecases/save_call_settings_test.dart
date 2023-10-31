// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/usecases/save_call_settings.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late SaveCallSettings usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = SaveCallSettings(mockRepository);
  });

  final callSettings =
      CallSetting(/* Initialize your CallSetting object here */);

  test('should save new CallSettings to the repository', () async {
    // Arrange
    when(mockRepository.saveCallSettings(callSettings)).thenAnswer(
      (_) => Right(callSettings),
    );

    // Act
    final result = await usecase.call(callSettings);

    // Assert
    expect(result, Right(callSettings));
    verify(mockRepository.saveCallSettings(callSettings));
    verifyNoMoreInteractions(mockRepository);
  });
}
