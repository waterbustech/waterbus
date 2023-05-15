// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@injectable
class UpdateUserProfile implements UseCase<User, User> {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}
