// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/usecases/login_with_social.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> onAuthCheck();
  Future<Either<Failure, User>> loginWithSocial(AuthParams params);
}
