// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@injectable
class UpdateUsername implements UseCase<bool, UpdateUsernameParams> {
  final UserRepository repository;

  UpdateUsername(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateUsernameParams params) async {
    return await repository.updateUsername(params.username);
  }
}

class UpdateUsernameParams extends Equatable {
  final String username;

  const UpdateUsernameParams({required this.username});

  @override
  List<Object> get props => [username];
}
