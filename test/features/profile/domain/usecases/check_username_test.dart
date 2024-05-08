// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/profile/domain/usecases/check_username.dart';
import 'get_presigned_url_test.mocks.dart';

void main() {
  late CheckUsername usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = CheckUsername(mockUserRepository);
  });

  test('should have correct prods', () {
    // Arrange
    const username1 = CheckUsernameParams(username: 'username1');
    const username2 = CheckUsernameParams(username: 'username2');

    // Act & Assert
    expect(username1.props, [username1.username]);
    expect(username2.props, [username2.username]);
    expect(username1.username, isNot(equals(username2.props)));
  });

  test('should return true when call checkUsername method from repository',
      () async {
    // Arrange
    const username = "username";

    const checkUsernameParams = CheckUsernameParams(username: username);

    when(mockUserRepository.checkUsername(username))
        .thenAnswer((_) async => const Right(true));

    // Act
    final result = await usecase(checkUsernameParams);

    // Assert
    expect(result, const Right(true));
    verify(mockUserRepository.checkUsername(username));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return false when call checkUsername method from repository',
      () async {
    // Arrange
    const username = "username";

    const checkUsernameParams = CheckUsernameParams(username: username);

    when(mockUserRepository.checkUsername(username))
        .thenAnswer((_) async => const Right(false));

    // Act
    final result = await usecase(checkUsernameParams);

    // Assert
    expect(result, const Right(false));
    verify(mockUserRepository.checkUsername(username));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return a failure when call checkUsername method from repository',
      () async {
    // Arrange
    const username = "username";

    const checkUsernameParams = CheckUsernameParams(username: username);

    when(mockUserRepository.checkUsername(username))
        .thenAnswer((_) async => Left(NullValue()));

    // Act
    final result = await usecase(checkUsernameParams);

    // Assert
    expect(result, Left(NullValue()));
    verify(mockUserRepository.checkUsername(username));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
