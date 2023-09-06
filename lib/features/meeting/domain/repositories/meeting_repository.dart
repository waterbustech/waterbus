// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';

abstract class MeetingRepository {
  Future<Either<Failure, Meeting>> createMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> updateMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> joinMeeting(CreateMeetingParams params);
  Future<Either<Failure, bool>> leaveMeeting();
  Future<Either<Failure, Meeting>> getInfoMeeting(GetMeetingParams params);
}
