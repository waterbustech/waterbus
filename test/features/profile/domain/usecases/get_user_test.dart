// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/usecases/get_profile.dart';
import 'get_presigned_url_test.mocks.dart';

void main() {
  late GetProfile usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetProfile(mockUserRepository);
  });

  test('should call getUserProfile method from the repository', () async {
    // Arrange
    final user = User(id: 1, userName: 'lambiengcode', fullName: 'Kai');
    when(mockUserRepository.getUserProfile())
        .thenAnswer((_) async => Right(user));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Right(user));
    verify(mockUserRepository.getUserProfile());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test(
      'should return a failure when getUserProfile method from the repository fails',
      () async {
    // Arrange
    when(mockUserRepository.getUserProfile())
        .thenAnswer((_) async => Left(ServerFailure()));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, Left(ServerFailure()));
    verify(mockUserRepository.getUserProfile());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
