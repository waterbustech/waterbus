// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@injectable
class CheckUsername implements UseCase<bool, CheckUsernameParams> {
  final UserRepository repository;

  CheckUsername(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckUsernameParams params) async {
    return await repository.checkUsername(params.username);
  }
}

class CheckUsernameParams extends Equatable {
  final String username;

  const CheckUsernameParams({required this.username});

  @override
  List<Object> get props => [username];
}
