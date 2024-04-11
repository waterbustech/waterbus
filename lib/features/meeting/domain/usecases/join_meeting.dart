// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';

@injectable
class JoinMeeting implements UseCase<Meeting, CreateMeetingParams> {
  final MeetingRepository repository;

  JoinMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(
    CreateMeetingParams params,
  ) async {
    if (params.password.isEmpty) {
      return await repository.joinMeetingWithoutPassword(params);
    }

    return await repository.joinMeetingWithPassword(params);
  }
}
