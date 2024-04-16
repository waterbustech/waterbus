// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus_sdk/models/index.dart';

// Project imports:
import 'package:waterbus/features/settings/presentation/widgets/setting_checkbox_card.dart';

class ThemesBottomSheet extends StatefulWidget {
  final String theme;
  final Function(String) onChanged;
  const ThemesBottomSheet({
    super.key,
    required this.theme,
    required this.onChanged,
  });

  @override
  State<ThemesBottomSheet> createState() => _ThemesBottomSheetState();
}

class _ThemesBottomSheetState extends State<ThemesBottomSheet> {
  late String _theme = widget.theme;
  final List<String> selectedThemes = [
    ThemeList.dark,
    ThemeList.light,
    ThemeList.system,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.sp,
        vertical: 25.sp,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Themes',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 12.sp),
          ...List.generate(
            selectedThemes.length,
            (index) => SettingCheckboxCard(
              label: selectedThemes[index],
              enabled: _theme == selectedThemes[index],
              hasDivider: index < VideoQuality.values.length - 1,
              onTap: () {
                setState(() {
                  _theme = selectedThemes[index];
                });
                widget.onChanged(_theme);
              },
            ),
          ),
        ],
      ),
    );
  }
}
