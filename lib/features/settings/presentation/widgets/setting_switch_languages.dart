import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/app/lang/data/data_languages.dart';
import 'package:waterbus/core/navigator/app_navigator.dart';
import 'package:waterbus/core/navigator/app_routes.dart';
import 'package:waterbus/features/settings/lang/language_service.dart';

class SettingLanguage extends StatelessWidget {
  const SettingLanguage({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Strings.selectLanguage.i18n,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
        TextButton(
          onPressed: () {
            AppNavigator().push(Routes.langRoute);
          },
          child: Text(
            LanguageService().getLocale().text,
          ),
        ),
      ],
    );
  }
}
