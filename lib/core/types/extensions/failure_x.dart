import 'package:waterbus_sdk/types/error/failures.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

extension ExceptionX on Failure? {
  String get messageException {
    late final String message;
    switch (this) {
      // Meeting
      case RoomNotFound _:
        message = Strings.roomNotFound.i18n;
      case NotAllowedToUpdateRoom _:
        message = Strings.notAllowedToUpdateRoom.i18n;
      case WrongPassword _:
        message = Strings.wrongPassword.i18n;
      case NotAllowToJoinDirectly _:
        message = Strings.notAllowToJoinDirectly.i18n;
      case NotExistsParticipant _:
        message = Strings.notExistsParticipant.i18n;
      case IsAlreadyInRoom _:
        message = Strings.isAlreadyInRoom.i18n;
      case HostNotFound _:
        message = Strings.hostNotFound.i18n;
      case NotAllowToAddUser _:
        message = Strings.notAllowToAddUser.i18n;
      case HasNotJoinedMeeting _:
        message = Strings.hasNotJoinedMeeting.i18n;
      case MemberNotFound _:
        message = Strings.memberNotFound.i18n;
      case ParticipantNotFound _:
        message = Strings.participantNotFound.i18n;
      case OnlyAllowHostStartRecord _:
        message = Strings.onlyAllowHostStartRecord.i18n;
      case OnlyAllowHostStopRecord _:
        message = Strings.onlyAllowHostStopRecord.i18n;
      case NotAllowedToLeaveTheRoom _:
        message = Strings.notAllowedToLeaveTheRoom.i18n;
      case OnlyHostPermitedToArchivedTheRoom _:
        message = Strings.onlyHostPermitedToArchivedTheRoom.i18n;
      // Message
      case NotAllowedModifyMessage _:
        message = Strings.notAllowedModifyMessage.i18n;
      case MessageNotFound _:
        message = Strings.messageNotFound.i18n;
      case MessageHasBeenDelete _:
        message = Strings.messageHasBeenDelete.i18n;
      // User
      case UserNotFound _:
        message = Strings.userNotFound.i18n;
      case UserIsAlreadyUsed _:
        message = Strings.userIsAlreadyUsed.i18n;
      default:
        message = Strings.serverFailure.i18n;
    }

    return message;
  }
}
