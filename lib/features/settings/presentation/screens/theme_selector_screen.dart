import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:waterbus/core/app/languages/localization.dart';
import 'package:waterbus/core/app/themes/preset.dart';
import 'package:waterbus/core/extensions/context_extensions.dart';
import 'package:waterbus/core/utils/sizer/sizer.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/common/widgets/app_bar_title_back.dart';
import 'package:waterbus/features/common/widgets/gesture_wrapper.dart';
import 'package:waterbus/features/settings/presentation/bloc/themes/themes_bloc.dart';

class ThemeSelectorScreen extends StatelessWidget {
  final bool isSettingDesktop;
  const ThemeSelectorScreen({super.key, this.isSettingDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.isMobile
          ? appBarTitleBack(
              context,
              leading: isSettingDesktop ? const SizedBox() : null,
              title: Strings.appearance.i18n,
            )
          : null,
      body: BlocBuilder<ThemesBloc, ThemesState>(
        builder: (context, theme) {
          final preset = theme.props.first as Preset;

          return SingleChildScrollView(
            child: Container(
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
                  Preset.values.length,
                  (index) => GestureWrapper(
                    onTap: () => AppBloc.themesBloc
                        .add(ThemeChanged(preset: Preset.values[index])),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Preset.values[index].label,
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
                                        Preset.values[index].name,
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
                                preset == Preset.values[index]
                                    ? Icon(
                                        LucideIcons.check200,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          if (index != Preset.values.length - 1)
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
          );
        },
      ),
    );
  }
}
