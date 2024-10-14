import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

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
    icon: PhosphorIcons.userCircle(),
  ),
  MenuItemModel(
    title: Strings.talkWithAI,
    icon: PhosphorIcons.robot(),
  ),
  MenuItemModel(
    title: Strings.storage,
    icon: PhosphorIcons.record(),
  ),
  MenuItemModel(
    title: Strings.archivedChats,
    icon: PhosphorIcons.archive(),
  ),
  MenuItemModel(
    title: Strings.settings,
    icon: PhosphorIcons.slidersHorizontal(),
  ),
  MenuItemModel(
    title: Strings.licenses,
    icon: PhosphorIcons.signature(),
  ),
  MenuItemModel(
    title: Strings.logout,
    icon: PhosphorIcons.signOut(),
  ),
];
