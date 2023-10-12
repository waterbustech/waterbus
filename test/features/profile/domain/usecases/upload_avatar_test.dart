// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/profile/domain/usecases/upload_avatar.dart';
import 'get_presigned_url_test.mocks.dart';

void main() {
  late UploadAvatar usecase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    usecase = UploadAvatar(mockRepository);
  });

  const testUploadUrl = 'https://example.com/upload';
  final testImage = File('path_to_image.png');
  const testImageUrl = 'https://example.com/image.png';

  test('should return the uploaded image URL from the repository', () async {
    // Arrange
    when(
      mockRepository.uploadImageToS3(
        uploadUrl: anyNamed('uploadUrl'),
        image: anyNamed('image'),
      ),
    ).thenAnswer((_) async => const Right(testImageUrl));

    // Act
    final result = await usecase(
      UploadAvatarParams(uploadUrl: testUploadUrl, image: testImage),
    );

    // Assert
    expect(result, const Right(testImageUrl));
    verify(
      mockRepository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return a failure from the repository', () async {
    // Arrange
    final failure =
        ServerFailure(); // Replace with the appropriate failure type
    when(
      mockRepository.uploadImageToS3(
        uploadUrl: anyNamed('uploadUrl'),
        image: anyNamed('image'),
      ),
    ).thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(
      UploadAvatarParams(uploadUrl: testUploadUrl, image: testImage),
    );

    // Assert
    expect(result, Left(failure));
    verify(
      mockRepository.uploadImageToS3(
        uploadUrl: testUploadUrl,
        image: testImage,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });

  test('should have correct props', () {
    // Arrange
    final param1 = UploadAvatarParams(
      uploadUrl: testImageUrl,
      image: testImage,
    );
    final param2 = UploadAvatarParams(
      uploadUrl: '$testImageUrl.tech',
      image: testImage,
    );

    // Act & Assert
    expect(param1.props, [param1.uploadUrl, param1.image]);
    expect(param2.props, [param2.uploadUrl, param2.image]);
    expect(param1.props, isNot(equals(param2.props)));
  });
}
