import 'package:auth/models/auth_payload_model.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginWithSocial implements UseCase<User, AuthParams> {
  final AuthRepository repository;

  LoginWithSocial(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthParams params) async {
    return await repository.loginWithSocial(params);
  }
}

class AuthParams extends Equatable {
  final AuthPayloadModel payloadModel;

  const AuthParams({required this.payloadModel});

  @override
  List<Object> get props => [payloadModel];
}
