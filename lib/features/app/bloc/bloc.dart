import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final AuthBloc authBloc = getIt<AuthBloc>();
  static final UserBloc userBloc = getIt<UserBloc>();
  static final MeetingBloc meetingBloc = getIt<MeetingBloc>();
  static final RecentJoinedBloc recentJoinedBloc = getIt<RecentJoinedBloc>();
  static final BeautyFiltersBloc beautyFiltersBloc = getIt<BeautyFiltersBloc>();
  static final ThemesBloc themesBloc = getIt<ThemesBloc>();
  static final DrawingBloc drawingBloc = getIt<DrawingBloc>();

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
      create: (context) => meetingBloc,
    ),
    BlocProvider<RecentJoinedBloc>(
      create: (context) => recentJoinedBloc,
    ),
    BlocProvider<BeautyFiltersBloc>(
      create: (context) => beautyFiltersBloc,
    ),
    BlocProvider<ThemesBloc>(
      create: (context) => themesBloc,
    ),
    BlocProvider<DrawingBloc>(
      create: (context) => drawingBloc,
    ),
    BlocProvider<DrawingBloc>(
      create: (context) => drawingBloc,
    ),
  ];

  Future<void> bootstrap() async {
    userBloc.add(GetProfileEvent());
    recentJoinedBloc.add(GetRecentJoinedEvent());
    meetingBloc.add(const InitializeMeetingEvent());
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
