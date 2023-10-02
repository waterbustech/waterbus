// Package imports:
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class GetParticipant implements UseCase<Participant, GetPariticipantParams> {
  final MeetingRepository repository;

  GetParticipant(this.repository);

  @override
  Future<Either<Failure, Participant>> call(
    GetPariticipantParams params,
  ) async {
    return await repository.getParticipantById(params.participantId);
  }
}

class GetPariticipantParams extends Equatable {
  final int participantId;

  const GetPariticipantParams({required this.participantId});

  @override
  List<Object> get props => [participantId];
}
