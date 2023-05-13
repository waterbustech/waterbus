import 'package:dartz/dartz.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateUserProfile();
}
