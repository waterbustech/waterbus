// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  @override
  Future<Either<Failure, User>> getUserProfile() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> updateUserProfile() {
    throw UnimplementedError();
  }
}
