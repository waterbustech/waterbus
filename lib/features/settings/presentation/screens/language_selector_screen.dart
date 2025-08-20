import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/settings/data/repositories/language_repository.dart';
import 'package:waterbus/features/settings/domain/entities/language.dart';
import 'package:waterbus/features/settings/domain/repositories/language_repository.dart';

class LanguageSelectorScreen extends StatefulWidget {
  final bool isSettingDesktop;
  const LanguageSelectorScreen({super.key, this.isSettingDesktop = false});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  final LanguageRepository _repository = LanguageRepositoryImpl();

  void _handleLanguageChanged(BuildContext context, Language language) {
    if (language == _repository.getLocale()) return;

    I18n.of(context).locale = language.locale;
    _repository.saveLocale(language.langCode);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile
          ? appBarTitleBack(
              context,
              leading: widget.isSettingDesktop ? const SizedBox() : null,
              title: Strings.language.i18n,
            )
          : null,
      body: Column(
        children: [
          const Divider(),
          Container(
            margin: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.sp),
              color: Theme.of(context).colorScheme.surfaceDim.withValues(
                    alpha: 0.25,
                  ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                Language.values.length,
                (index) => GestureWrapper(
                  onTap: () => _handleLanguageChanged(
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
                              _repository.getLocale().langCode ==
                                      Language.values[index].langCode
                                  ? Icon(
                                      LucideIcons.check200,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        if (index != Language.values.length - 1)
                          Padding(
                            padding: EdgeInsets.only(left: 12.sp),
                            child: const Divider(),
                          ),
                      ],
                    ),
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
