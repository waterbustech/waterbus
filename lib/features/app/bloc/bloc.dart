import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/chat_bloc.dart';
import 'package:waterbus/features/chats/presentation/bloc/invited_chat_bloc.dart';
import 'package:waterbus/features/conversation/bloc/message_bloc.dart';
import 'package:waterbus/features/home/bloc/home/home_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/beauty_filters/beauty_filters_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/drawing/drawing_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/meeting/meeting_bloc.dart';
import 'package:waterbus/features/meeting/presentation/bloc/recent_joined/recent_joined_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_bloc.dart';
import 'package:waterbus/features/profile/presentation/bloc/user_search_bloc.dart';
import 'package:waterbus/features/settings/themes/bloc/themes_bloc.dart';

class AppBloc {
  static final HomeBloc homeBloc = getIt<HomeBloc>();
  static final AuthBloc authBloc = getIt<AuthBloc>();
  static final UserBloc userBloc = getIt<UserBloc>();
  static final UserSearchBloc userSearchBloc = getIt<UserSearchBloc>();
  static final MeetingBloc meetingBloc = getIt<MeetingBloc>();
  static final ChatBloc chatBloc = getIt<ChatBloc>();
  static final InvitedChatBloc invitedChatBloc = getIt<InvitedChatBloc>();
  static final MessageBloc messageBloc = getIt<MessageBloc>();
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
    BlocProvider<UserSearchBloc>(
      create: (context) => userSearchBloc,
    ),
    BlocProvider<MeetingBloc>(
      create: (context) => meetingBloc,
    ),
    BlocProvider<ChatBloc>(
      create: (context) => chatBloc,
    ),
    BlocProvider<InvitedChatBloc>(
      create: (context) => invitedChatBloc,
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
    BlocProvider<DrawingBloc>(
      create: (context) => drawingBloc,
    ),
  ];

  Future<void> bootstrap() async {
    userBloc.add(GetProfileEvent());
    recentJoinedBloc.add(GetRecentJoinedEvent());
    meetingBloc.add(InitializeMeetingEvent());
    chatBloc.add(OnChatEvent());
    messageBloc.add(InitialMessageSocketEvent());
  }

  ///Singleton factory
  static final AppBloc instance = AppBloc._internal();

  factory AppBloc() {
    return instance;
  }

  AppBloc._internal();
}
