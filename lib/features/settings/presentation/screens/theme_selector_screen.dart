import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class ThemeSelectorScreen extends StatelessWidget {
  final bool isSettingDesktop;
  const ThemeSelectorScreen({super.key, this.isSettingDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile
          ? appBarTitleBack(
              context,
              leading: isSettingDesktop ? const SizedBox() : null,
              title: Strings.appearance.i18n,
            )
          : null,
      body: BlocBuilder<ThemesBloc, ThemesState>(
        builder: (context, theme) {
          final mode = theme.props.first as ThemeMode;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider,
                _buildTitle(context, Strings.colorMode.i18n),
                SizedBox(
                  height: 40.sp,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      ThemeMode.values.length,
                      (index) => _buildOptionTheme(
                        context,
                        ThemeMode.values[index],
                        mode,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.sp),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _buildOptionTheme(
    BuildContext context,
    ThemeMode theme,
    ThemeMode currentMode,
  ) {
    return GestureWrapper(
      onTap: () {
        AppBloc.themesBloc.add(ThemeChanged(mode: theme));
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8.sp),
        child: Material(
          color: Colors.transparent,
          shape: SuperellipseShape(
            borderRadius: BorderRadius.circular(10.sp),
            side: BorderSide(
              width: currentMode == theme ? 2 : 1,
              color: currentMode == theme
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.sp,
              vertical: 8.sp,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Row(
                children: [
                  Icon(_getIconData(theme), size: 16.sp),
                  SizedBox(width: 5.sp),
                  Text(
                    theme.name.i18n,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.dark:
        return PhosphorIcons.moonStars();
      case ThemeMode.light:
        return PhosphorIcons.sun();
      default:
        return PhosphorIcons.laptop();
    }
  }
}
