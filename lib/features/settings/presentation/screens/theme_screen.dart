import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:superellipse_shape/superellipse_shape.dart';

import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/types/enums/color_seed.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/settings/presentation/widgets/custom_row_button.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class ThemeScreen extends StatelessWidget {
  final bool isSettingDesktop;
  const ThemeScreen({super.key, this.isSettingDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        leading: isSettingDesktop ? const SizedBox() : null,
        title: Strings.appearance.i18n,
      ),
      body: BlocBuilder<ThemesBloc, ThemesState>(
        builder: (context, theme) {
          final mode = theme.props.first as ThemeMode;
          final colorSeed = theme.props.last as ColorSeed;

          return Column(
            children: [
              divider,
              Padding(
                padding: EdgeInsets.all(20.sp),
                child: Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      ThemeMode.values.length,
                      (index) => CustomRowButton(
                        groupValue: mode.name,
                        onTap: () {
                          AppBloc.themesBloc.add(
                            OnThemeChangedEvent(
                              mode: ThemeMode.values[index],
                            ),
                          );
                        },
                        value: ThemeMode.values[index].name,
                        text: ThemeMode.values[index].name.i18n,
                        showDivider: index != ThemeMode.values.length - 1,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Material(
                  shape: SuperellipseShape(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  child: SizedBox(
                    height: 42.sp,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      scrollDirection: Axis.horizontal,
                      itemCount: ColorSeed.values.length,
                      itemBuilder: (ctx, index) {
                        final color = ColorSeed.values[index];

                        return GestureWrapper(
                          onTap: () {
                            AppBloc.themesBloc.add(
                              OnColorSeedChangedEvent(colorSeed: color),
                            );
                          },
                          child: Container(
                            height: 26.5.sp,
                            width: 26.5.sp,
                            margin: EdgeInsets.only(right: 10.sp),
                            decoration: BoxDecoration(
                              color: color.color,
                              shape: BoxShape.circle,
                              border: colorSeed != color
                                  ? null
                                  : Border.all(
                                      color: ColorScheme.fromSeed(
                                        seedColor: color.color,
                                      ).primary,
                                      width: 3.sp,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
