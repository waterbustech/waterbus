// Package imports:
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/core/usecase/usecase.dart';
import 'package:waterbus/features/meeting/domain/repositories/meeting_repository.dart';
import 'package:waterbus/services/webrtc/models/call_setting.dart';

@injectable
class SaveCallSettings implements UseCase<CallSetting, CallSetting> {
  final MeetingRepository repository;

  SaveCallSettings(this.repository);

  @override
  Future<Either<Failure, CallSetting>> call(CallSetting setting) async {
    return repository.saveCallSettings(setting);
  }
}
