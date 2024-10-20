import 'package:flutter/material.dart';

import 'package:waterbus/features/profile/presentation/models/menu_items.dart';
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
      physics: const NeverScrollableScrollPhysics(),
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
