import 'package:flutter/material.dart';

import 'package:re_editor/re_editor.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';

class ContextMenuItemWidget extends PopupMenuItem<void>
    implements PreferredSizeWidget {
  ContextMenuItemWidget({
    super.key,
    required String text,
    required VoidCallback super.onTap,
  }) : super(
          child: Text(text),
        );

  @override
  Size get preferredSize => const Size(150, 25);
}

class ContextMenuControllerImpl implements SelectionToolbarController {
  const ContextMenuControllerImpl();

  @override
  void hide(BuildContext context) {}

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    showMenu(
      context: context,
      position: RelativeRect.fromSize(
        anchors.primaryAnchor & const Size(150, double.infinity),
        MediaQuery.of(context).size,
      ),
      items: [
        ContextMenuItemWidget(
          text: Strings.cut.i18n,
          onTap: () {
            controller.cut();
          },
        ),
        ContextMenuItemWidget(
          text: Strings.copy.i18n,
          onTap: () {
            controller.copy();
          },
        ),
        ContextMenuItemWidget(
          text: Strings.paste.i18n,
          onTap: () {
            controller.paste();
          },
        ),
      ],
    );
  }
}
