// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/usecases/get_call_settings.dart';
import 'package:waterbus/services/webrtc/models/call_setting.dart';
import 'create_meeting_test.mocks.dart';

void main() {
  late GetCallSettings usecase;
  late MockMeetingRepository mockRepository;

  setUp(() {
    mockRepository = MockMeetingRepository();
    usecase = GetCallSettings(mockRepository);
  });

  final callSettings =
      CallSetting(/* Initialize your CallSetting object here */);

  test('should get CallSettings from the repository', () async {
    // Arrange
    when(mockRepository.getCallSettings()).thenAnswer(
      (_) => Right(callSettings),
    );

    // Act
    final result = await usecase.call(null);

    // Assert
    expect(result, Right(callSettings));
    verify(mockRepository.getCallSettings());
    verifyNoMoreInteractions(mockRepository);
  });
}
