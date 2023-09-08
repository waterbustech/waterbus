// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:sizer/sizer.dart';

// Project imports:
import 'package:waterbus/core/app/colors/app_color.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

const int delay300ms = 300;
const int delay500ms = 500;

const int connectTimeOut = 10000;
const int receiveTimeOut = 10000;

const unlimited = 99999;

Widget dividerContainer = Container(
  color: colorBlack1,
  height: 6.sp,
);

Divider divider = Divider(
  height: 1.sp,
  color: colorGreyWhite,
);

const User defaultUser = User(
  id: 0,
  fullName: 'Waterbus',
  userName: 'waterbus.io',
  avatar: 'https://avatars.githubusercontent.com/u/60530946?v=4',
);
