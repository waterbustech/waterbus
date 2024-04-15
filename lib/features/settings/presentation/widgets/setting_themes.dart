import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class SettingThemes extends StatelessWidget {
  const SettingThemes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Change Themes",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            IconButton(
              onPressed: () {
                AppBloc.themesBloc.add(OnChangeTheme(appTheme: state.props[0]));
              },
              icon: state.props[0] == ThemeList.dark
                  ? Icon(
                      PhosphorIcons.moon_stars_fill,
                      color: Theme.of(context).primaryColor,
                    )
                  : Icon(
                      PhosphorIcons.sun_fill,
                      color: Theme.of(context).primaryColor,
                    ),
            ),
          ],
        );
      },
    );
  }
}
