// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';

@LazySingleton(as: MeetingRepository)
class MeetingRepositoryImpl extends MeetingRepository {
  @override
  Future<Either<Failure, Meeting>> createMeeting(CreateMeetingParams params) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> getInfoMeeting(GetMeetingParams params) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> joinMeeting(CreateMeetingParams params) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> leaveMeeting() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Meeting>> updateMeeting(CreateMeetingParams params) {
    throw UnimplementedError();
  }
}
