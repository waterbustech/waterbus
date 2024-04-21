// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:i18n_extension/i18n_extension.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/app/lang/models/language_model.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';
import 'package:waterbus/features/settings/presentation/widgets/custom_row_button.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  void _handleChangeLanguage(BuildContext context, Language language) {
    if (language == LanguageService().getLocale()) return;

    I18n.of(context).locale = language.locale;
    LanguageService().saveLocale(language.langCode);

    setState(() {});
  }

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
            borderRadius: BorderRadius.circular(8.sp),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              Language.values.length,
              (index) => CustomRowButton(
                groupValue: LanguageService().getLocale().langCode,
                onTap: () => _handleChangeLanguage(
                  context,
                  Language.values[index],
                ),
                value: Language.values[index].langCode,
                text: Language.values[index].text.i18n,
                showDivider: index != Language.values.length - 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
