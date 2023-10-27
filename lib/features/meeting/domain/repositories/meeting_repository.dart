// Package imports:
import 'package:dartz/dartz.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';
import 'package:waterbus/services/webrtc/models/call_setting.dart';

abstract class MeetingRepository {
  Future<Either<Failure, List<Meeting>>> getRecentJoined();
  Future<Either<Failure, Meeting>> createMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> updateMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> joinMeeting(CreateMeetingParams params);
  Future<Either<Failure, Meeting>> leaveMeeting(LeaveMeetingParams params);
  Future<Either<Failure, Meeting>> getInfoMeeting(GetMeetingParams params);
  Either<Failure, bool> cleanAllRecentJoined();
  Future<Either<Failure, Participant>> getParticipantById(int participantId);
  Either<Failure, CallSetting> saveCallSettings(CallSetting setting);
  Either<Failure, CallSetting> getCallSettings();
}
