import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

class MenuItemModel {
  final String title;
  final IconData icon;

  const MenuItemModel({
    required this.title,
    required this.icon,
  });
}

final List<MenuItemModel> menuItems = [
  MenuItemModel(
    title: Strings.profile,
    icon: LucideIcons.circleUser,
  ),
  // MenuItemModel(
  //   title: Strings.talkWithAI,
  //   icon: LucideIcons.robot,
  // ),
  MenuItemModel(
    title: Strings.archivedChats,
    icon: LucideIcons.archive,
  ),
  MenuItemModel(
    title: Strings.settings,
    icon: LucideIcons.slidersHorizontal,
  ),
  MenuItemModel(
    title: Strings.licenses,
    icon: LucideIcons.badgeCheck,
  ),
  MenuItemModel(
    title: Strings.logout,
    icon: LucideIcons.logOut,
  ),
];
