// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/localization.dart';
import 'package:waterbus/core/app/themes/theme_model.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
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
      body: Column(
        children: [
          divider,
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  ThemeList.values.length,
                  (index) => BlocBuilder<ThemesBloc, ThemesState>(
                    builder: (context, stateThemes) {
                      return CustomRowButton(
                        groupValue: stateThemes.props[0].text,
                        onTap: () {
                          AppBloc.themesBloc.add(
                            OnChangeTheme(appTheme: ThemeList.values[index]),
                          );
                        },
                        value: ThemeList.values[index].text,
                        text: ThemeList.values[index].text.i18n,
                        showDivider: index != ThemeList.values.length - 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
