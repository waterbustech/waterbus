import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/lang/language_service.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/app/lang/models/language_model.dart';

class LanguageScreenState extends StatefulWidget {
  const LanguageScreenState({super.key});

  @override
  State<LanguageScreenState> createState() => _LanguageScreenStateState();
}

class _LanguageScreenStateState extends State<LanguageScreenState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.selectLanguage.i18n),
      ),
      body: ListView.builder(
        itemCount: Language.values.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Row(
                children: [
                  Image.asset(
                    "assets/country_flags/${Language.values[index].langCode}.png",
                    height: 20.sp,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(Language.values[index].text),
                ],
              ),
              onTap: () {
                I18n.of(context).locale = Language.values[index].locale;
                LanguageService().saveLocale(Language.values[index].langCode);
                AppNavigator.pop();
              },
            ),
          );
        },
      ),
    );
  }
}
