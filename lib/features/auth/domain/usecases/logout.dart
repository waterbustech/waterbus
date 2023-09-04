// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LogOut implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  LogOut(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams? params) async {
    return await repository.logOut();
  }
}
