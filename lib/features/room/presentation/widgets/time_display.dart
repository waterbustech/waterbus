import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:waterbus_sdk/utils/extensions/duration_extension.dart';

import 'package:waterbus/core/helpers/date_time_helper.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  State<StatefulWidget> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final now = DateTime.now();

    final secondsUntilNextMinute = 60 - now.second;

    Timer(Duration(seconds: secondsUntilNextMinute), () {
      setState(() {
        _currentTime = DateTime.now();
      });

      _timer = Timer.periodic(1.minutes, (timer) {
        setState(() {
          _currentTime = DateTime.now();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeHelper().formatDateTime(_currentTime),
      style: TextStyle(
        fontSize: 11.sp,
      ),
    );
  }
}
