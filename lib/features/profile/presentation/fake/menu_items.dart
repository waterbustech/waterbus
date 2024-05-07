// Project imports:
import 'package:flutter/material.dart';
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
  const MenuItemModel(
    title: Strings.profile,
    icon: Icons.person_3_outlined,
  ),
  const MenuItemModel(
    title: Strings.storage,
    icon: Icons.folder_open_outlined,
  ),
  const MenuItemModel(
    title: Strings.archivedChats,
    icon: Icons.bookmark_outline,
  ),
  const MenuItemModel(
    title: Strings.settings,
    icon: Icons.widgets_outlined,
  ),
  const MenuItemModel(
    title: Strings.licenses,
    icon: Icons.local_police_outlined,
  ),
  const MenuItemModel(
    title: Strings.logout,
    icon: Icons.logout_outlined,
  ),
];
