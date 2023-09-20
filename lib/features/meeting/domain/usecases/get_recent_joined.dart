// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class GetRecentJoined implements UseCase<List<Meeting>, NoParams> {
  final MeetingRepository repository;

  GetRecentJoined(this.repository);

  @override
  Future<Either<Failure, List<Meeting>>> call(NoParams? noParams) async {
    return await repository.getRecentJoined();
  }
}
