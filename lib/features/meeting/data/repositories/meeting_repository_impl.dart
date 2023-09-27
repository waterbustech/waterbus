// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_local_datasource.dart';
import 'package:waterbus/features/meeting/data/datasources/meeting_remote_datasource.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:waterbus/features/meeting/domain/usecases/create_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/get_info_meeting.dart';
import 'package:waterbus/features/meeting/domain/usecases/leave_meeting.dart';

@LazySingleton(as: MeetingRepository)
class MeetingRepositoryImpl extends MeetingRepository {
  final MeetingRemoteDataSource _remoteDataSource;
  final MeetingLocalDataSource _localDataSource;

  MeetingRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, Meeting>> createMeeting(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.createMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) {
      return Left(NullValue());
    }

    meeting = _findMyParticipantObject(meeting);
    _localDataSource.insertOrUpdate(meeting);

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> getInfoMeeting(
    GetMeetingParams params,
  ) async {
    final Meeting? meeting = await _remoteDataSource.getInfoMeeting(
      params.code,
    );

    if (meeting == null) return Left(NullValue());

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> joinMeeting(
    CreateMeetingParams params,
  ) async {
    Meeting? meeting = await _remoteDataSource.joinMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (meeting == null) return Left(NullValue());

    meeting = _findMyParticipantObject(meeting);
    _localDataSource.insertOrUpdate(meeting);

    return Right(meeting);
  }

  @override
  Future<Either<Failure, Meeting>> updateMeeting(
    CreateMeetingParams params,
  ) async {
    final bool isUpdateSucceed = await _remoteDataSource.updateMeeting(
      meeting: params.meeting,
      password: params.password,
    );

    if (!isUpdateSucceed) return Left(NullValue());

    _localDataSource.insertOrUpdate(params.meeting);

    return Right(params.meeting);
  }

  @override
  Future<Either<Failure, Meeting>> leaveMeeting(
    LeaveMeetingParams params,
  ) async {
    final bool isLeaveSucceed = await _remoteDataSource.leaveMeeting(
      code: params.code,
      participantId: params.participantId,
    );

    if (isLeaveSucceed) {
      final int indexOfMeetingInRecent = _localDataSource.meetings.indexWhere(
        (meeting) => meeting.code == params.code,
      );

      if (indexOfMeetingInRecent != -1) {
        final List<Participant> participants =
            _localDataSource.meetings[indexOfMeetingInRecent].participants;

        final int indexOfParticipant = participants.indexWhere(
          (participant) => participant.isMe,
        );

        if (indexOfParticipant != -1) {
          participants[indexOfParticipant] =
              participants[indexOfParticipant].copyWith(
            status: StatusEnum.inactive,
          );

          final Meeting meeting =
              _localDataSource.meetings[indexOfMeetingInRecent].copyWith(
            participants: participants,
          );

          _localDataSource.insertOrUpdate(meeting);

          return Right(meeting);
        }
      }
    }

    return Left(NullValue());
  }

  @override
  Future<Either<Failure, List<Meeting>>> getRecentJoined() async {
    final List<Meeting> meetings = _localDataSource.meetings;

    return Right(meetings);
  }

  @override
  Either<Failure, bool> cleanAllRecentJoined() {
    _localDataSource.removeAll();
    return const Right(true);
  }

  Meeting _findMyParticipantObject(Meeting meeting) {
    final int indexOfMyParticipant = meeting.participants.lastIndexWhere(
      (participant) => participant.user.id == AppBloc.userBloc.user?.id,
    );

    if (indexOfMyParticipant == -1) return meeting;

    meeting.participants[indexOfMyParticipant].isMe = true;

    return meeting;
  }
}
