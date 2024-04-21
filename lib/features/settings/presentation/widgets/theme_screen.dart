// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/app/themes/theme_model.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.selectTheme.i18n,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).cardColor,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ThemeList.values.length,
            itemBuilder: (context, index) {
              return BlocBuilder<ThemesBloc, ThemesState>(
                builder: (context, stateThemes) {
                  return RadioListTile<String>(
                    activeColor: Theme.of(context).textTheme.bodyLarge?.color,
                    title: Text(ThemeList.values[index].text.i18n),
                    value: ThemeList.values[index].text,
                    groupValue: stateThemes.props[0].text,
                    onChanged: (value) {
                      AppBloc.themesBloc.add(
                        OnChangeTheme(appTheme: ThemeList.values[index]),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
