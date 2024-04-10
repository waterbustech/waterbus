// Project imports:
import 'package:waterbus/gen/assets.gen.dart';

class MenuItemModel {
  final String title;
  final String iconAssetPath;

  const MenuItemModel({
    required this.title,
    required this.iconAssetPath,
  });
}

final List<MenuItemModel> menuItems = [
  MenuItemModel(
    title: 'Profile',
    iconAssetPath: Assets.icons.icProfile.path,
  ),
  MenuItemModel(
    title: 'Storage',
    iconAssetPath: Assets.icons.icFolder.path,
  ),
  MenuItemModel(
    title: 'Archived chats',
    iconAssetPath: Assets.icons.icArchive.path,
  ),
  MenuItemModel(
    title: 'Licenses',
    iconAssetPath: Assets.icons.icShield.path,
  ),
  MenuItemModel(
    title: 'Logout',
    iconAssetPath: Assets.icons.icLogOut.path,
  ),
];
