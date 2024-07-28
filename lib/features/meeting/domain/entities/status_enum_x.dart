import 'package:waterbus_sdk/types/enums/status_enum.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

extension MemberStatusEnumX on MemberStatusEnum {
  String get title => switch (this) {
        MemberStatusEnum.inviting => Strings.inviting.i18n,
        MemberStatusEnum.invisible => Strings.invisible.i18n,
        MemberStatusEnum.joined => Strings.joined.i18n,
      };
}
