// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:waterbus/features/profile/data/repositories/user_repository_impl.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRemoteDataSource>()])
void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(mockDataSource);
  });

  const testUser = User(id: 1, userName: 'testuser', fullName: 'Test User');

  group('getUserProfile', () {
    test('should return user from remote data source', () async {
      // Arrange
      when(mockDataSource.getUserProfile()).thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result, const Right(testUser));
      verify(mockDataSource.getUserProfile());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.getUserProfile())
          .thenAnswer((realInvocation) async => null);

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result, Left(NullValue()));
      verify(mockDataSource.getUserProfile());
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('updateUserProfile', () {
    test('should return updated user from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUserProfile(testUser))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateUserProfile(testUser);

      // Assert
      expect(result, const Right(testUser));
      verify(mockDataSource.updateUserProfile(testUser));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUserProfile(testUser))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.updateUserProfile(testUser);

      // Assert
      expect(result, Left(NullValue()));
      verify(mockDataSource.updateUserProfile(testUser));
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('getPresignedUrl', () {
    test('should return presigned URL from remote data source', () async {
      // Arrange
      const testUrl = 'https://example.com/presigned-url';
      when(mockDataSource.getPresignedUrl()).thenAnswer((_) async => testUrl);

      // Act
      final result = await repository.getPresignedUrl();

      // Assert
      expect(result, const Right(testUrl));
      verify(mockDataSource.getPresignedUrl());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.getPresignedUrl()).thenAnswer(
        (realInvocation) async => null,
      );

      // Act
      final result = await repository.getPresignedUrl();

      // Assert
      expect(result, Left(NullValue()));
      verify(mockDataSource.getPresignedUrl());
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
