// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';

@injectable
class GetCallSettings implements UseCase<CallSetting, NoParams> {
  final MeetingRepository repository;

  GetCallSettings(this.repository);

  @override
  Future<Either<Failure, CallSetting>> call(NoParams? noParams) async {
    return repository.getCallSettings();
  }
}
