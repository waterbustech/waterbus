// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class UpdateMeeting implements UseCase<bool, LeaveMeetingParams> {
  final MeetingRepository repository;

  UpdateMeeting(this.repository);

  @override
  Future<Either<Failure, bool>> call(LeaveMeetingParams params) async {
    return await repository.leaveMeeting(params);
  }
}

class LeaveMeetingParams extends Equatable {
  final int code;
  final int participantId;

  const LeaveMeetingParams({
    required this.code,
    required this.participantId,
  });

  @override
  List<Object> get props => [code, participantId];
}
