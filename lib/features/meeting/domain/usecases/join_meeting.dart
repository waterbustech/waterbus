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
class CreateMeeting implements UseCase<Meeting, CreateMeetingParams> {
  final MeetingRepository repository;

  CreateMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(CreateMeetingParams params) async {
    return await repository.joinMeeting(params);
  }
}
