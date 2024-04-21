// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
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
    title: Strings.profile,
    iconAssetPath: Assets.icons.icProfile.path,
  ),
  MenuItemModel(
    title: Strings.storage,
    iconAssetPath: Assets.icons.icFolder.path,
  ),
  MenuItemModel(
    title: Strings.archivedChats,
    iconAssetPath: Assets.icons.icArchive.path,
  ),
  MenuItemModel(
    title: Strings.settings,
    iconAssetPath: Assets.icons.icSettings.path,
  ),
  MenuItemModel(
    title: Strings.licenses,
    iconAssetPath: Assets.icons.icShield.path,
  ),
  MenuItemModel(
    title: Strings.logout,
    iconAssetPath: Assets.icons.icLogOut.path,
  ),
];
