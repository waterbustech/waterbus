// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

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
      body: Container(
        padding: EdgeInsets.all(16.sp),
        child: Text(
          'MIT License\n\nCopyright (c) 2023 lambiengcode\n\n'
          'Permission is hereby granted, free of charge, to any person obtaining a copy of this software '
          'and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights'
          'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell'
          'copies of the Software, and to permit persons to whom the Software is'
          'furnished to do so, subject to the following conditions:\n\n'
          'The above copyright notice and this permission notice shall be included in all'
          'copies or substantial portions of the Software.\n\n'
          'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR'
          'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,'
          'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE'
          'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER'
          'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,'
          'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 11.sp,
              ),
        ),
      ),
    );
  }
}
