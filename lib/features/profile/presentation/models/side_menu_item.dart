import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

typedef IconStyle = PhosphorIconsStyle;

class SideMenuItem {
  final String label;
  final IconData iconData;
  SideMenuItem({
    required this.label,
    required this.iconData,
  });
}

final List<SideMenuItem> sideMenuItems = [
  SideMenuItem(
    label: Strings.recent,
    iconData: LucideIcons.proportions,
  ),
  SideMenuItem(
    label: Strings.chat,
    iconData: LucideIcons.messageCircle,
  ),
  SideMenuItem(
    label: Strings.archivedChats,
    iconData: LucideIcons.archive,
  ),
];

final List<SideMenuItem> accountMenuItems = [
  SideMenuItem(
    label: Strings.notifications,
    iconData: LucideIcons.bell,
  ),
  SideMenuItem(
    label: Strings.appearance,
    iconData: LucideIcons.paintbrush,
  ),
  SideMenuItem(
    label: Strings.language,
    iconData: LucideIcons.globe,
  ),
  SideMenuItem(
    label: Strings.callSettings,
    iconData: LucideIcons.video,
  ),
  SideMenuItem(
    label: Strings.licenses,
    iconData: LucideIcons.badgeCheck,
  ),
];
