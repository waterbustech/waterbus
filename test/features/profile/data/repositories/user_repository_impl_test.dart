// Dart imports:
import 'dart:typed_data';

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

  final testUser = User(id: 1, userName: 'testuser', fullName: 'Test User');

  group('getUserProfile', () {
    test('should return user from remote data source', () async {
      // Arrange
      when(mockDataSource.getUserProfile()).thenAnswer((_) async => testUser);

      // Act
      final result = await repository.getUserProfile();

      // Assert
      expect(result, Right(testUser));
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
      expect(result, Right(testUser));
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

  group('updateUsername', () {
    test('should return true from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUsername(testUser.userName))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateUsername(testUser.userName);

      // Assert
      expect(result, const Right(true));
      verify(mockDataSource.updateUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure from remote data source', () async {
      // Arrange
      when(mockDataSource.updateUsername(testUser.userName))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.updateUsername(testUser.userName);

      // Assert
      expect(result, Left(NullValue()));
      verify(mockDataSource.updateUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('checkUsername', () {
    test('should return true from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result, const Right(true));
      verify(mockDataSource.checkUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return false from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result, const Right(false));
      verify(mockDataSource.checkUsername(testUser.userName));
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return null from remote data source', () async {
      // Arrange
      when(mockDataSource.checkUsername(testUser.userName))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.checkUsername(testUser.userName);

      // Assert
      expect(result, Left(NullValue()));
      verify(mockDataSource.checkUsername(testUser.userName));
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

  group('uploadImageToS3', () {
    const testUploadUrl = 'https://example.com/upload';
    final testImage = Uint8List(69);
    const testImageUrl = 'https://example.com/image.png';

    test('should return the uploaded image URL', () async {
      // Arrange
      when(
        mockDataSource.uploadImageToS3(
          uploadUrl: anyNamed('uploadUrl'),
          image: anyNamed('image'),
        ),
      ).thenAnswer((_) async => testImageUrl);

      // Act
      final result = await repository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      );

      // Assert
      expect(result, const Right(testImageUrl));
      verify(
        mockDataSource.uploadImageToS3(
          uploadUrl: testUploadUrl,
          image: testImage,
        ),
      );
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a failure when upload fails', () async {
      // Arrange
      when(
        mockDataSource.uploadImageToS3(
          uploadUrl: anyNamed('uploadUrl'),
          image: anyNamed('image'),
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      );

      // Assert
      expect(result, Left(NullValue()));
      verify(
        mockDataSource.uploadImageToS3(
          uploadUrl: testUploadUrl,
          image: testImage,
        ),
      );
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
