// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:waterbus/core/utils/appbar/app_bar_title_back.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitleBack(
        context,
        'Term & Privacy',
      ),
    );
  }
}
