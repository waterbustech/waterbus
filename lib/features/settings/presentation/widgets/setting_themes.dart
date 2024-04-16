import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/core/utils/modal/show_dialog.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/settings/presentation/widgets/setting_switch_card.dart';
import 'package:waterbus/features/settings/presentation/widgets/themes_bottom_sheet.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class SettingThemes extends StatefulWidget {
  const SettingThemes({super.key});

  @override
  State<SettingThemes> createState() => _SettingThemesState();
}

class _SettingThemesState extends State<SettingThemes> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemesBloc, ThemesState>(
      builder: (context, state) {
        return GestureWrapper(
          onTap: () {
            showDialogWaterbus(
              alignment: Alignment.center,
              child: ThemesBottomSheet(
                theme: state.appThemeName,
                onChanged: (selectedThemes) {
                  setState(() {
                    AppBloc.themesBloc.add(
                      OnChangeTheme(
                        appTheme: selectedThemes == ThemeList.dark
                            ? ThemeMode.dark
                            : ThemeMode.light,
                      ),
                    );
                  });
                },
              ),
            );
          },
          child: SettingSwitchCard(
            label: "Themes",
            enabled: true,
            hasDivider: false,
            value: state.appThemeName,
            onChanged: (isEnabled) {},
          ),
        );
      },
    );
  }
}
