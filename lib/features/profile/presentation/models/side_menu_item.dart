import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

typedef IconStyle = PhosphorIconsStyle;

class SideMenuItem {
  final String label;
  final IconData iconData;
  final IconData selectedIconData;
  SideMenuItem({
    required this.label,
    required this.iconData,
    required this.selectedIconData,
  });
}

final List<SideMenuItem> sideMenuItems = [
  SideMenuItem(
    label: Strings.recent,
    iconData: PhosphorIcons.presentationChart(),
    selectedIconData: PhosphorIcons.presentationChart(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.chat,
    iconData: PhosphorIcons.chatsTeardrop(),
    selectedIconData: PhosphorIcons.chatsTeardrop(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.talkWithAI,
    iconData: PhosphorIcons.robot(),
    selectedIconData: PhosphorIcons.robot(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.archivedChats,
    iconData: PhosphorIcons.archive(),
    selectedIconData: PhosphorIcons.archive(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.storage,
    iconData: PhosphorIcons.record(),
    selectedIconData: PhosphorIcons.record(IconStyle.fill),
  ),
];

final List<SideMenuItem> accountMenuItems = [
  SideMenuItem(
    label: Strings.notifications,
    iconData: PhosphorIcons.bell(),
    selectedIconData: PhosphorIcons.bell(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.appearance,
    iconData: PhosphorIcons.circleHalf(),
    selectedIconData: PhosphorIcons.circleHalf(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.language,
    iconData: PhosphorIcons.translate(),
    selectedIconData: PhosphorIcons.translate(PhosphorIconsStyle.bold),
  ),
  SideMenuItem(
    label: Strings.callSettings,
    iconData: PhosphorIcons.videoCamera(),
    selectedIconData: PhosphorIcons.videoCamera(IconStyle.fill),
  ),
  SideMenuItem(
    label: Strings.licenses,
    iconData: PhosphorIcons.signature(),
    selectedIconData: PhosphorIcons.signature(IconStyle.bold),
  ),
];
