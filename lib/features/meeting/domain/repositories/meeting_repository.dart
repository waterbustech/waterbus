// Package imports:
import 'package:dartz/dartz.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';

abstract class MeetingRepository {
  Future<Either<Failure, List<Meeting>>> getRecentJoined();
  Future<Either<Failure, Meeting>> createMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> updateMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> joinMeetingWithPassword(
    CreateMeetingParams params,
  );
  Future<Either<Failure, Meeting>> joinMeetingWithoutPassword(
    CreateMeetingParams params,
  );
  Future<Either<Failure, Meeting>> getInfoMeeting(GetMeetingParams params);
  Either<Failure, bool> removeRecentJoined(int code);
  Either<Failure, bool> cleanAllRecentJoined();

  Either<Failure, CallSetting> saveCallSettings(CallSetting setting);
  Either<Failure, CallSetting> getCallSettings();
}
