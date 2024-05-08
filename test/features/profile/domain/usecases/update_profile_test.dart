// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/usecases/update_profile.dart';
import 'get_presigned_url_test.mocks.dart';

void main() {
  late UpdateProfile usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateProfile(mockUserRepository);
  });

  test('should have correct props', () {
    // Arrange
    final user1 = UpdateUserParams(
      user: User(id: 1, userName: 'user1', fullName: 'User One', bio: 'bio1'),
    );
    final user2 = UpdateUserParams(
      user: User(id: 2, userName: 'user2', fullName: 'User Two', bio: 'bio2'),
    );

    // Act & Assert
    expect(user1.props, [user1.user]);
    expect(user2.props, [user2.user]);
    expect(user1.props, isNot(equals(user2.props)));
  });

  test('should call updateUserProfile method from the repository', () async {
    // Arrange
    final user = User(
      id: 1,
      userName: 'lambiengcode',
      fullName: 'Kai',
      bio: 'bio1',
    );

    final updateUserParams = UpdateUserParams(user: user);
    when(mockUserRepository.updateUserProfile(user))
        .thenAnswer((_) async => Right(user));

    // Act
    final result = await usecase(updateUserParams);

    // Assert
    expect(result, Right(user));
    verify(mockUserRepository.updateUserProfile(user));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test(
      'should return a failure when updateUserProfile method from the repository fails',
      () async {
    // Arrange
    final user = User(
      id: 1,
      userName: 'lambiengcode',
      fullName: 'Kai',
      bio: 'bio1',
    );

    final updateUserParams = UpdateUserParams(user: user);
    when(mockUserRepository.updateUserProfile(user))
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(updateUserParams);

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockUserRepository.updateUserProfile(user));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
