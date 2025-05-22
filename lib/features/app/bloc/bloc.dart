import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/archived/presentation/bloc/archived_bloc.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/room/presentation/bloc/room/room_bloc.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final AuthBloc authBloc = getIt<AuthBloc>();
  static final UserBloc userBloc = getIt<UserBloc>();
  static final RoomBloc roomBloc = getIt<RoomBloc>();
  static final ChatBloc chatBloc = getIt<ChatBloc>();
  static final ArchivedBloc archivedBloc = getIt<ArchivedBloc>();
  static final MessageBloc messageBloc = getIt<MessageBloc>();
  static final RecentJoinedBloc recentJoinedBloc = getIt<RecentJoinedBloc>();
  static final BeautyFiltersBloc beautyFiltersBloc = getIt<BeautyFiltersBloc>();
  static final ThemesBloc themesBloc = getIt<ThemesBloc>();

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
    BlocProvider<ArchivedBloc>(
      create: (context) => archivedBloc,
    ),
    BlocProvider<RoomBloc>(
      create: (context) => roomBloc,
    ),
    BlocProvider<ChatBloc>(
      create: (context) => chatBloc,
    ),
    BlocProvider<MessageBloc>(
      create: (context) => messageBloc,
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
  ];

  Future<void> bootstrap() async {
    userBloc.add(UserFetched());
    recentJoinedBloc.add(RecentJoinedStarted());
    roomBloc.add(RoomStarted());
    chatBloc.add(ChatStarted());
    messageBloc.add(MessageSocketStarted());
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
