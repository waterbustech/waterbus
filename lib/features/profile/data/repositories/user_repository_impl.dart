// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  late final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    final UserModel? userResponse = await _remoteDataSource.getUserProfile();

    if (userResponse == null) return Left(NullValue());

    return Right(User.fromUserModel(userResponse));
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    final UserModel? userResponse = await _remoteDataSource.updateUserProfile(
      UserModel.fromUserEntity(user),
    );

    if (userResponse == null) return Left(NullValue());

    return Right(user);
  }
}
