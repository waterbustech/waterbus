// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';

@injectable
class GetPresignedUrl implements UseCase<String, NoParams> {
  final UserRepository repository;

  GetPresignedUrl(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams? params) async {
    return await repository.getPresignedUrl();
  }
}
