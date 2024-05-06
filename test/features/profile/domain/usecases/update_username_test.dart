// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/profile/domain/usecases/update_username.dart';
import 'get_presigned_url_test.mocks.dart';

void main() {
  late UpdateUsername usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateUsername(mockUserRepository);
  });

  test('should have correct props', () {
    // Arrange
    const username1 = UpdateUsernameParams(username: 'username1');
    const username2 = UpdateUsernameParams(username: 'username2');

    // Act & Assert
    expect(username1.props, [username1.username]);
    expect(username2.props, [username2.username]);
    expect(username1.props, isNot(equals(username2.props)));
  });

  test('should return true when call updateUsername method from the repository',
      () async {
    // Arrange
    const username = 'username';

    const updateUsernameParams = UpdateUsernameParams(username: username);

    when(mockUserRepository.updateUsername(username))
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(updateUsernameParams);

    // Assert
    expect(result, const Right(true));
    verify(mockUserRepository.updateUsername(username));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test(
      'should return a failure when call updateUsername method from the repository',
      () async {
    // Arrange
    const username = 'username';

    const updateUsernameParams = UpdateUsernameParams(username: username);

    when(mockUserRepository.updateUsername(username))
        .thenAnswer((_) async => Left(NullValue()));

    // Act
    final result = await usecase(updateUsernameParams);

    // Assert
    expect(result, Left(NullValue()));
    verify(mockUserRepository.updateUsername(username));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
