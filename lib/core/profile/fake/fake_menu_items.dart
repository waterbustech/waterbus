import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class MenuItemModel {
  final String title;
  final IconData iconData;
  const MenuItemModel({
    required this.title,
    required this.iconData,
  });
}

final List<MenuItemModel> fakeMenuItems = [
  const MenuItemModel(title: 'Profile', iconData: PhosphorIcons.user_circle),
  const MenuItemModel(title: 'Appearance', iconData: PhosphorIcons.palette),
  const MenuItemModel(title: 'Settings', iconData: PhosphorIcons.gear_six),
  const MenuItemModel(
    title: 'Term & Privacy',
    iconData: PhosphorIcons.shield_check,
  ),
];
