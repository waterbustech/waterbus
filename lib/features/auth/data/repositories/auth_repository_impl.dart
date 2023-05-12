import 'package:injectable/injectable.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:waterbus/features/auth/domain/repositories/auth_repository.dart';
import 'package:waterbus/features/auth/domain/usecases/login_with_social.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithSocial(AuthParams params) async {
    final UserModel? response = await _remoteDataSource.signInWithSocial(
      params.payloadModel,
    );

    if (response == null) return Left(NullValue());

    _localDataSource.saveUserModel(response);

    return Right(User.fromUserModel(response));
  }

  @override
  Future<Either<Failure, User>> onAuthCheck() async {
    final UserModel? user = _localDataSource.getUserModel();

    if (user != null) {
      return Right(User.fromUserModel(user));
    }

    return Left(NullValue());
  }
}
