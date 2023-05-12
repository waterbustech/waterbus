import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/repositories/auth_repository.dart';

@injectable
class CheckAuth implements UseCase<User, NoParams> {
  final AuthRepository repository;

  CheckAuth(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams? params) async {
    return await repository.onAuthCheck();
  }
}
