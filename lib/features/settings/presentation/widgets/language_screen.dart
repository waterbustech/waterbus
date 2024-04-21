// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:i18n_extension/i18n_extension.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/app/lang/models/language_model.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});
  final String _selectedItem = LanguageService().getLocale().langCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        title: Strings.selectLanguage.i18n,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).primaryColor,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Language.values.length,
            itemBuilder: (context, index) {
              return RadioListTile<String>(
                activeColor: Theme.of(context).textTheme.bodyLarge?.color,
                title: Text(Language.values[index].text),
                value: Language.values[index].langCode,
                groupValue: _selectedItem,
                onChanged: (value) {
                  I18n.of(context).locale = Language.values[index].locale;
                  LanguageService().saveLocale(value!);
                  AppNavigator.pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
