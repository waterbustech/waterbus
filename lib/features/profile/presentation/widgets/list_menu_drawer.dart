// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/features/profile/presentation/fake/fake_menu_items.dart';
import 'package:waterbus/features/profile/presentation/widgets/menu_drawer_card.dart';

class ListMenuDrawer extends StatelessWidget {
  final Function(MenuItemModel) onTapItem;
  const ListMenuDrawer({
    super.key,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            onTapItem(menuItems[index]);
          },
          child: MenuDrawerCard(item: menuItems[index]),
        );
      },
    );
  }
}
