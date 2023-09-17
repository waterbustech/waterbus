// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class GetInfoMeeting implements UseCase<Meeting, GetMeetingParams> {
  final MeetingRepository repository;

  GetInfoMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(GetMeetingParams params) async {
    return await repository.getInfoMeeting(params);
  }
}

class GetMeetingParams extends Equatable {
  final int code;

  const GetMeetingParams({required this.code});

  @override
  List<Object> get props => [code];
}
