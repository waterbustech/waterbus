// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/schedule/blocs/schedule/schedule_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final ScheduleBloc scheduleBloc = getIt<ScheduleBloc>();
  static final AuthBloc authBloc = getIt<AuthBloc>();
  static final UserBloc userBloc = getIt<UserBloc>();
  static final MeetingBloc meetingBloc = getIt<MeetingBloc>();

  static final List<BlocProvider> providers = [
    BlocProvider<AuthBloc>(
      create: (context) => authBloc,
    ),
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
    BlocProvider<ScheduleBloc>(
      create: (context) => scheduleBloc,
    ),
    BlocProvider<UserBloc>(
      create: (context) => userBloc,
    ),
    BlocProvider<MeetingBloc>(
      create: (context) => meetingBloc,
    ),
  ];

  void bootstrap() {
    userBloc.add(GetProfileEvent());
    meetingBloc.add(GetRecentJoinedEvent());
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
