// Dart imports:
import 'dart:typed_data';

// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateUserProfile(User user);
  Future<Either<Failure, String>> getPresignedUrl();
  Future<Either<Failure, String>> uploadImageToS3({
    required String uploadUrl,
    required Uint8List image,
  });
}
