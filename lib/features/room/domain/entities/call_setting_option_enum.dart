import 'package:flutter/foundation.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/languages/localization.dart';

enum CallSettingOptionEnum {
  settings,
  virtualBackground,
  beautyFilters,
  shareLink,
  chat;

  static List<CallSettingOptionEnum> get settingsDesktop {
    final List<CallSettingOptionEnum> settings =
        List.from(CallSettingOptionEnum.values);

    settings.removeWhere(
      (item) =>
          item == CallSettingOptionEnum.chat ||
          (kIsWeb && item == CallSettingOptionEnum.beautyFilters),
    );

    return settings;
  }

  String get label => switch (this) {
        CallSettingOptionEnum.settings => Strings.settings,
        CallSettingOptionEnum.virtualBackground => Strings.virtualBackground,
        CallSettingOptionEnum.beautyFilters => Strings.beautyFilters,
        CallSettingOptionEnum.shareLink => Strings.shareLink,
        CallSettingOptionEnum.chat => Strings.chat,
      };

  PhosphorIconData get icon => switch (this) {
        CallSettingOptionEnum.settings => PhosphorIcons.gear(),
        CallSettingOptionEnum.virtualBackground =>
          PhosphorIcons.selectionBackground(),
        CallSettingOptionEnum.beautyFilters => PhosphorIcons.fire(),
        CallSettingOptionEnum.shareLink => PhosphorIcons.shareFat(),
        CallSettingOptionEnum.chat => PhosphorIcons.chatTeardropText(),
      };
}
