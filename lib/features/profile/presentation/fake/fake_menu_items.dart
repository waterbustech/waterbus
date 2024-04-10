// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';

class MenuItemModel {
  final String title;
  final IconData iconData;
  const MenuItemModel({
    required this.title,
    required this.iconData,
  });
}

final List<MenuItemModel> menuItems = [
  const MenuItemModel(
    title: Strings.profile,
    iconData: PhosphorIcons.user_circle,
  ),
  const MenuItemModel(
    title: Strings.settings,
    iconData: PhosphorIcons.sliders_horizontal,
  ),
  const MenuItemModel(
    title: Strings.licenses,
    iconData: PhosphorIcons.shield_check,
  ),
  const MenuItemModel(
    title: Strings.logout,
    iconData: PhosphorIcons.sign_out,
  ),
];
