import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/enums/color_seed.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class ThemeScreen extends StatelessWidget {
  final bool isSettingDesktop;
  const ThemeScreen({super.key, this.isSettingDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SizerUtil.isDesktop
          ? Theme.of(context).colorScheme.surfaceContainerLow
          : null,
      appBar: appBarTitleBack(
        context,
        leading: isSettingDesktop ? const SizedBox() : null,
        title: Strings.appearance.i18n,
      ),
      body: BlocBuilder<ThemesBloc, ThemesState>(
        builder: (context, theme) {
          final mode = theme.props.first as ThemeMode;
          final colorSeed = theme.props.last as ColorSeed;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider,
                _buildTitle(context, 'Color Mode'),
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
                _buildTitle(context, 'Primary Color'),
                GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (100.w / 150.sp).round(),
                    mainAxisSpacing: 8.sp,
                    crossAxisSpacing: 8.sp,
                    childAspectRatio: 3,
                  ),
                  itemCount: ColorSeed.values.length,
                  itemBuilder: (ctx, index) {
                    final color = ColorSeed.values[index];

                    return GestureWrapper(
                      onTap: () {
                        AppBloc.themesBloc.add(
                          OnColorSeedChangedEvent(colorSeed: color),
                        );
                      },
                      child: Material(
                        color: Colors.transparent,
                        shape: SuperellipseShape(
                          borderRadius: BorderRadius.circular(10.sp),
                          side: BorderSide(
                            width: colorSeed == color ? 2 : 1,
                            color: colorSeed != color
                                ? Colors.grey
                                : ColorScheme.fromSeed(
                                    seedColor: color.color,
                                  ).primary,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 8.sp),
                            Container(
                              height: 16.sp,
                              width: 16.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.color,
                              ),
                            ),
                            SizedBox(width: 5.sp),
                            Text(
                              color.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
        AppBloc.themesBloc.add(OnThemeChangedEvent(mode: theme));
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
