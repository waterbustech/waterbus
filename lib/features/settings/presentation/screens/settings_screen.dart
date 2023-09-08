// Flutter imports:
import 'package:flutter/material.dart';
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Settings',
      ),
    );
  }
}
