import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/platform_utils.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/home/widgets/side_footer_body.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/models/side_menu_item.dart';
import 'package:waterbus/features/profile/presentation/widgets/avatar_card.dart';
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
      maxWidth: 250.sp,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (data) => SideMenuData(
        header: _buildHeader(context),
        items: [
          SideMenuItemDataDivider(
            padding: EdgeInsetsDirectional.symmetric(vertical: 0.sp),
            divider: Divider(
              color: Theme.of(context).dividerColor,
              height: 1,
              thickness: 1,
            ),
          ),
          ..._buildListItem(context, sideMenuItems),
          SideMenuItemDataDivider(
            padding: EdgeInsetsDirectional.symmetric(vertical: 10.sp),
            divider: Divider(
              color: Colors.transparent,
            ),
          ),
          if (!_isCollapsed)
            SideMenuItemDataTitle(
              title: Strings.settings.i18n,
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.sp),
              titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 11.sp,
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
    final appLogo = Assets.images.logoRounded.image(height: 24.sp);

    return Container(
      height: 50.sp,
      margin: EdgeInsets.only(
        top: PlatformUtils.isMacOS ? 10.sp : 4.sp,
      ),
      padding: EdgeInsets.all(12.sp),
      child: _isCollapsed
          ? appLogo
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    spacing: 10.sp,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      appLogo,
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.sp),
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: kAppTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: GoogleFonts.ibmPlexMono()
                                            .fontFamily,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
            borderRadius: BorderRadius.circular(2.sp),
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
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            selectedTitleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.secondary,
                ),
            icon: Icon(item.value.iconData, size: 17.sp),
            selectedIcon: Icon(
              item.value.iconData,
              size: 18.sp,
              fill: 1,
            ),
          ),
        )
        .toList();
  }

  Widget _buildFooter(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        final User user = state is UserDone ? state.user : kUserDefault;

        final userAvatar = AvatarCard(
          urlToImage: user.avatar,
          size: 32.sp,
          label: user.fullName,
        );

        if (_isCollapsed) {
          return Container(
            margin: EdgeInsets.all(12.sp),
            child: userAvatar,
          );
        }

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.sp),
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          margin: EdgeInsets.all(8.sp),
          padding: EdgeInsets.symmetric(horizontal: 6.sp),
          child: SideFooterBody(
            userAvatar: userAvatar,
            user: user,
          ),
        );
      },
    );
  }
}
