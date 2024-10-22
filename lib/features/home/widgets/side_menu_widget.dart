import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/types/models/user_model.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/home/widgets/side_footer_body.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/models/side_menu_item.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';
import 'package:waterbus/gen/assets.gen.dart';

class SideMenuWidget extends StatefulWidget {
  final Function(String) onTabChanged;
  const SideMenuWidget({super.key, required this.onTabChanged});

  @override
  State<StatefulWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  final _controller = SideMenuController();
  String _currentTab = sideMenuItems.first.label;

  bool get _isCollapsed => _controller.isCollapsed();

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      hasResizer: false,
      hasResizerToggle: false,
      controller: _controller,
      mode: SideMenuMode.open,
      maxWidth: 22.w,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      builder: (data) => SideMenuData(
        header: _buildHeader(context),
        items: [
          ..._buildListItem(context, sideMenuItems),
          SideMenuItemDataDivider(
            padding: EdgeInsetsDirectional.symmetric(vertical: 16.sp),
            divider: Divider(
              height: .5,
              thickness: .5,
              indent: 10.sp,
              endIndent: 10.sp,
            ),
          ),
          if (!_isCollapsed)
            SideMenuItemDataTitle(
              title: Strings.settings.i18n,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.sp),
              titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ..._buildListItem(context, accountMenuItems),
        ],
        footer: _buildFooter(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final appLogo = Assets.images.imgAppLogo3d.image(height: 30.sp);

    return Container(
      margin: EdgeInsets.only(top: 12.sp),
      padding: EdgeInsets.all(12.sp),
      child: _isCollapsed
          ? appLogo
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    appLogo,
                    SizedBox(width: 6.sp),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.5.sp),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Waterbus',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            TextSpan(
                              text: '\t\t$kAppVersion',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 8.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    AppBloc.themesBloc.add(
                      OnThemeChangedEvent(
                        mode: Theme.of(context).brightness == Brightness.light
                            ? ThemeMode.dark
                            : ThemeMode.light,
                      ),
                    );
                  },
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? PhosphorIcons.sunDim(PhosphorIconsStyle.fill)
                        : PhosphorIcons.moonStars(PhosphorIconsStyle.fill),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
    );
  }

  List<SideMenuItemData> _buildListItem(
    BuildContext context,
    List<SideMenuItem> data,
  ) {
    return data
        .asMap()
        .entries
        .map(
          (item) => SideMenuItemDataTile(
            itemHeight: 38.sp,
            hasSelectedLine: false,
            highlightSelectedColor: Colors.transparent,
            isSelected: _currentTab == item.value.label,
            onTap: () {
              setState(() => _currentTab = item.value.label);
              widget.onTabChanged(_currentTab);
            },
            title: item.value.label.i18n,
            titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 13.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            selectedTitleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            icon: Icon(item.value.iconData, size: 17.sp),
            selectedIcon: Icon(item.value.selectedIconData, size: 18.sp),
          ),
        )
        .toList();
  }

  Widget _buildFooter(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final User user = state is UserGetDone ? state.user : kUserDefault;

        final userAvatar = AvatarCard(
          urlToImage: user.avatar,
          size: 32.sp,
          title: user.fullName,
        );

        if (_isCollapsed) {
          return Container(
            margin: EdgeInsets.all(12.sp),
            child: userAvatar,
          );
        }

        return Container(
          margin: EdgeInsets.all(12.sp),
          child: SideFooterBody(
            userAvatar: userAvatar,
            user: user,
          ),
        );
      },
    );
  }
}
