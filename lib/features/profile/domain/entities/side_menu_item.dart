import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/languages/localization.dart';

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
    iconData: LucideIcons.layoutDashboard,
  ),
  SideMenuItem(
    label: Strings.chat,
    iconData: LucideIcons.mails,
  ),
  SideMenuItem(
    label: Strings.archivedChats,
    iconData: LucideIcons.package,
  ),
];

final List<SideMenuItem> accountMenuItems = [
  SideMenuItem(
    label: Strings.notifications,
    iconData: LucideIcons.megaphone,
  ),
  SideMenuItem(
    label: Strings.appearance,
    iconData: LucideIcons.paintbrush,
  ),
  SideMenuItem(
    label: Strings.language,
    iconData: LucideIcons.bookA,
  ),
  SideMenuItem(
    label: Strings.callSettings,
    iconData: LucideIcons.video,
  ),
  SideMenuItem(
    label: Strings.licenses,
    iconData: LucideIcons.scale,
  ),
];
