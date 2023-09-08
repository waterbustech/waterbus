// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@injectable
class GetProfile implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams? params) async {
    return await repository.getUserProfile();
  }
}
