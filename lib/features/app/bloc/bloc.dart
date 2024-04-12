// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/systems/bloc/themes/theme_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final AuthBloc authBloc = getIt<AuthBloc>();
  static final UserBloc userBloc = getIt<UserBloc>();
  static final ThemeBloc themeBloc = getIt<ThemeBloc>();
  static final MeetingBloc meetingBloc = getIt<MeetingBloc>();
  static final RecentJoinedBloc recentJoinedBloc = getIt<RecentJoinedBloc>();
  static final BeautyFiltersBloc beautyFiltersBloc = getIt<BeautyFiltersBloc>();

  static final List<BlocProvider> providers = [
    BlocProvider<AuthBloc>(
      create: (context) => authBloc,
    ),
    BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
    ),
    BlocProvider<UserBloc>(
      create: (context) => userBloc,
    ),
    BlocProvider<MeetingBloc>(
      lazy: false,
      create: (context) => meetingBloc,
    ),
    BlocProvider<RecentJoinedBloc>(
      create: (context) => recentJoinedBloc,
    ),
    BlocProvider<BeautyFiltersBloc>(
      create: (context) => beautyFiltersBloc,
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => themeBloc,
    ),
  ];

  void bootstrap() {
    userBloc.add(GetProfileEvent());
    recentJoinedBloc.add(GetRecentJoinedEvent());
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
