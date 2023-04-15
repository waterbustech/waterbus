import 'package:flutter/material.dart';
import 'package:waterbus/core/profile/fake/fake_menu_items.dart';
import 'package:waterbus/core/profile/widgets/menu_drawer_card.dart';

class ListMenuDrawer extends StatelessWidget {
  const ListMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: fakeMenuItems.length,
      itemBuilder: (context, index) {
        return MenuDrawerCard(item: fakeMenuItems[index]);
      },
    );
  }
}
