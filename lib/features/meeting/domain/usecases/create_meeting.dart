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
class CreateMeeting implements UseCase<Meeting, CreateMeetingParams> {
  final MeetingRepository repository;

  CreateMeeting(this.repository);

  @override
  Future<Either<Failure, Meeting>> call(CreateMeetingParams params) async {
    return await repository.createMeeting(params);
  }
}

class CreateMeetingParams extends Equatable {
  final Meeting meeting;
  final String password;

  const CreateMeetingParams({required this.meeting, required this.password});

  @override
  List<Object> get props => [meeting, password];
}
