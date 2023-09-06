// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class UpdateMeeting implements UseCase<bool, NoParams> {
  final MeetingRepository repository;

  UpdateMeeting(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams? params) async {
    return await repository.leaveMeeting();
  }
}
