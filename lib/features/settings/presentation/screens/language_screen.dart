// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/app/lang/models/language_model.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';
import 'package:waterbus/core/utils/gesture/gesture_wrapper.dart';
import 'package:waterbus/features/common/styles/style.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

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
        title: Strings.language.i18n,
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
              (index) => GestureWrapper(
                onTap: () => _handleChangeLanguage(
                  context,
                  Language.values[index],
                ),
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.sp,
                          vertical: 5.sp,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Language.values[index].text.i18n,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 1.sp),
                                  Text(
                                    Language.values[index].base,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LanguageService().getLocale().langCode ==
                                    Language.values[index].langCode
                                ? Icon(
                                    PhosphorIcons.check,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      if (index != Language.values.length - 1)
                        Padding(
                          padding: EdgeInsets.only(left: 12.sp),
                          child: divider,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
